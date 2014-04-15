Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaDOOJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaDOOJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:09:00 -0400
Date: Tue, 15 Apr 2014 10:08:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Takenori Nagano <t-nagano@ah.jp.nec.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in
 unstable condition
Message-ID: <20140415140853.GA17018@redhat.com>
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140414193153.GC4281@redhat.com>
 <534C8D64.2070108@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C8D64.2070108@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:37:40AM +0900, Masami Hiramatsu wrote:

[..]
> > Masami,
> > 
> > So what's the alternative to kdump which is more reliable? IOW, what
> > action you are planning to take through kmsg_dump() or through
> > panic_notifiers?
> > 
> > I have seen that many a times developers have tried to make the case 
> > to save kernel buffers to NVRAM. Does it work well? Has it been proven
> > to be more reliable than kdump?
> 
> Yeah, one possible option is the NVRAM, but even with the serial,
> there are other reasons to kick the notifiers, e.g.
>  - dump to ipmi which has a very small amount of non-volatile memory
>  - ftrace_dump() to dump "flight recorder" log to serial

So why do we need to run them in crashed kernel? Only argument I seem
to receive that there is no guarantee that kdump kernel will successfully
boot hence we want to run these notifiers.

But what's the guarantee that these will run successfully without creating
futher issues? Is there data to prove it.

>  - pvpanic notifies panic to the host.

I think this pvpanic() notification can go in kdump kernel too? Anyway,
if one has configured kdump, then host does not have to do anything to
save dump. Host might want to know for informational purposes that panic
happend and system rebooted. So there should not be any need to send
this notification immediately after crash?

> 
> Anyway, I think the most important reason for linux developers is
> that we have a chance to improve such horrible notifiers to safer,

I think big debate here is that we should be able to do most of it
in second kernel. 

If you provide a knob to run these in first kernel, this functionality
will never migrate to second kernel. And trying to make them safe in
crashed kernel is a losing battle, I think.

So providing this knob does not help with making these notifiers better.
These notifiers can become better only if migrate the functionality
to second kernel (preferrably in user space). There we can extract all
the data from /proc/vmcore and send it whereever you want.

But for that you will have to trust kdump and keep on improving it
constantly so that it works reasonably well.

> or at least to clarify what notifier or behavior makes kdump unstable. :-)
> 

I think that's well known. We don't have to provide a knob to prove that
running notifiers will make kdump less reliable.

Thanks
Vivek
