Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaGUSGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:06:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55459 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:06:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
	<1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
	<CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
	<20140721124725.GB111224@ubuntu-hedt>
	<CAJfpegs=V5BpNdgn1JSLsvUsAnmhPvGJZobF1y_NAysb==Z1-A@mail.gmail.com>
	<20140721143442.GD111224@ubuntu-hedt>
Date: Mon, 21 Jul 2014 11:02:53 -0700
In-Reply-To: <20140721143442.GD111224@ubuntu-hedt> (Seth Forshee's message of
	"Mon, 21 Jul 2014 09:34:42 -0500")
Message-ID: <87r41er3n6.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ZyLDWQ+f0R3AK1plvHC4BdClKCRgQBuY=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4397]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/3] fuse: Allow mounts from user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Mon, Jul 21, 2014 at 03:09:14PM +0200, Miklos Szeredi wrote:
>> On Mon, Jul 21, 2014 at 2:47 PM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > On Fri, Jul 18, 2014 at 05:33:23PM +0200, Miklos Szeredi wrote:
>> >> On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
>> >> <seth.forshee@canonical.com> wrote:
>> >> > Update fuse to allow mounts from user namespaces. During mount
>> >> > current_user_ns() is stashed away,
>> >>
>> >> Same thing here.  While practically this may work, it's theoretically
>> >> wrong, and possibly may go wrong in special situations.   In fuse
>> >> there's no official "server process", so storing information, like
>> >> namespace, about one is going to be wrong.
>> >
>> > What you're suggesting would probably work fine when dealing with pids.
>> > It's not going to work though for the checks I've added in
>> > fuse_allow_current_process() that the process is in the mount owner's
>> > user ns, and without those checks or something similar I don't think
>> > it's safe to permit allow_other for user ns mounts.
>> 
>> You can add that check in fuse_dev_do_read() as well.  If the
>> fsuid/fsgid doesn't exist in the "server's" namespace, then set
>> req->out.h.error and call request_end().
>
> Okay, that seems like it should work.
>
>> > Can you elaborate on what special situations might violate these
>> > assumptions or otherwise cause problems?
>> 
>> What's preventing a fuse fs implementation from handling FUSE_INIT in
>> one process and then handling the rest in a different process
>> (possibly in a different namespace)?
>
> Nothing, but I'm having a hard time imagining why that would ever be
> useful. The user/group ids passed in the mount options would have to be
> mapped into that namespace, otherwise all requests will just fail in the
> check you suggest above. The only thing I can think of would be if
> someone wanted to proxy mounts trough a process in a more privileged
> context, but then the main point of these patches is to make that
> unnecessary.
>
> But I also think your approach should work just as well as mine for the
> use cases that do make sense to me, so I'll go ahead and give it a
> try.

A few observations that I don't think I have seen come up in this
thread.

In my earlier experiments with mounting filesystems in other user
namespaces it did wind up making sense to have a notion of this is
the user namespace that things are represented in on disk, and
that wound up covering odd corner cases like acls.  For fuse
I don't recall if any of those corner cases exists.

At the same time my conversion experience also showed that performing
the conversion to/from kuid and kgids as close to the user space
interface as close as possible was the lease error prone and most
secure way of handling things.

For the file descriptors used for talking to a fuse server I would be
inclined to capture a user and pid namespace at open time to use for
your conversions.   This avoids using current and getting into the
problem of file descriptors that change behavior when passed from
process to process.

I definitely agree that using kuids kgids, and struct pid through the
fuse filesystem internally is the least error prone way to go.

Eric
