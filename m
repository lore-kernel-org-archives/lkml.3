Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEWWlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:41:01 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55053 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaEWWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <1400846226.25914.16.camel@debian>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
	<537C040E.3040901@jp.fujitsu.com>
	<1400637782.14703.32.camel@debian>
	<537C12BC.6080408@jp.fujitsu.com>
	<1400642398.14703.42.camel@debian>
	<537C1F24.8000604@jp.fujitsu.com>
	<3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
	<1400808739.19982.48.camel@debian>
	<20140523091041.GA21332@pd.tnic>
	<1400846226.25914.16.camel@debian>
Date: Fri, 23 May 2014 15:40:58 -0700
Message-ID: <CA+8MBbJ=zFPFJ=3e6qez_eJZ23AN+s5MF2DsvCDYXPpRvBxt+A@mail.gmail.com>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
From: Tony Luck <tony.luck@gmail.com>
To: Chen Yucong <slaoub@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 4:57 AM, Chen Yucong <slaoub@gmail.com> wrote:
> If (mca_cfg.tolerant == 2 || mce_cfg.tolerant == 3), what can you do for
> it?

Maybe we need to look again at the effects of "tolerant" - and maybe
specify what happens at various levels,  There are some obvious
silly bits of code (picking one that is my fault):
        if (cfg->tolerant < 3) {
                if (no_way_out)
                        mce_panic("Fatal machine check on current
CPU", &m, msg);
                if (worst == MCE_AR_SEVERITY) {
                        /* schedule action before return to userland */
                        mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
                        set_thread_flag(TIF_MCE_NOTIFY);
                } else if (kill_it) {
                        force_sig(SIGBUS, current);
                }
        }

Why is the MCE_AR_SEVERITY recovery code not even attempted
if tolerant is >=3?  That block of code dates back to before there were
any recoverable cases ... so the insane option of just ignoring the error
and hoping that the end result wasn't too bad made some sort of sense
when compared against a machine crash and not getting any answer at
all.

Or one that Andi pointed out years ago (and had a fix in a tree for):

        if (order == 1) {
                /* CHECKME: Can this race with a parallel hotplug? */
                int cpus = num_online_cpus();

                /*
                 * Monarch: Wait for everyone to go through their scanning
                 * loops.
                 */
                while (atomic_read(&mce_executing) <= cpus) {

What if some cpus were offline when this machine check arrived?
Our "offline" code doesn't do anything to the h/w to prevent those
cpus from joining in the machine check fun. So we'll see more than
num_online_cpus() processors arrive to process the machine check.
Andi's fix was in the start of do_machine_check() and just had each
cpu that showed up check whether it was listed as "online" by Linux.
If not, it just cleared MCG_STATUS and returned.  I didn't apply it
because I thought we needed to be a bit more robust (what if the offline
cpu actually did have a problem? ... we should at least check that
MCG_STATUS.RIPV=1 before rashly returning ... perhaps even more
tests are needed if the cpu had never been online at all).

So I'm happy that you are taking an interest in machine check code.
I think there are places where it can be made a lot better. I don't
think that moving where mces_seen gets cleared is one of those
places.

-Tony
