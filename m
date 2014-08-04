Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaHDXDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:03:04 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60071 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaHDXDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:03:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Ram Pai <linuxram@us.ibm.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jeff Mahoney <jeffm@suse.com>, sahne@0x90.at,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
	<53D959A7.5070702@nod.at> <53DAC069.7070606@nod.at>
	<20140801154448.GE24719@ram.oc3035372033.ibm.com>
	<53DBE894.3020900@nod.at> <87ha1v6ewb.fsf@x220.int.ebiederm.org>
	<CAFLxGvzbdON+fbsG=0iwOv5m_hbQ2=Pz=Ec-AHq728FTNcx4iw@mail.gmail.com>
	<874mxs2of1.fsf@x220.int.ebiederm.org> <53DFF8E7.2060906@nod.at>
Date: Mon, 04 Aug 2014 15:59:08 -0700
In-Reply-To: <53DFF8E7.2060906@nod.at> (Richard Weinberger's message of "Mon,
	04 Aug 2014 23:19:35 +0200")
Message-ID: <87ppgfzwsj.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19qQfr8gCkgGBp0HwC6ZrzAe1xC87c0TXA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: MNT_DETACH and mount namespace issue
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 04.08.2014 18:46, schrieb Eric W. Biederman:
>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>> 
>>> On Sat, Aug 2, 2014 at 12:09 AM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
[snip]
>> 
>> Hmm.  That problem does sound familiar.
>> 
>> Is the problem oversharing?  Is the problem that the mount of /proc in
>> the chroot directory is propogating into other mount namespaces that
>> don't care?
>
> /proc is propagating into another mount namespaces that does not care.
> This happens because systemd creates for several services a mount namespace and sets
> the root tree to MS_SHARED.

Unless you are in the primary mount namespace when having this issue
it would be good to run mount make-rprivate / before mounting your new
/proc.

>> If the problem is over propogating I would argue that KIWI needs to
>> use a mount namespace instead of a chroot and to tweak the mount
>> namespace so the mount of /proc simply does not leak out.
>> 
>> Not that the kernel doesn't need to be fixed but that a design where
>> mounts propogate everywhere is a problem in userspace anyway, and it is
>> likely going to only need to be a handful of lines of code to fix
>> userspace cleanly.  While the kernel fix or fixes are going to require a
>> bit more time.
>
> KIWI can bypass the issue by not using a lazy unmount of /proc.
> But I fear more applications will need fixing.
> While I don't think that it was a wise choice from systemd developers to set
> / shared by default I agree that systemd is not the root cause of the problem.
> It is the messenger.
>
> It is just annoying that applications stopped working correctly after upgrading
> to systemd.

Quite.

The deep issue here is actually the design of how mount propogation
works.  If you want the option of mounts to propogate then you are
required to make them shared to start with then after creating a mount
namespace if you don't want that sharing you have to do
"mount --make-rprivate /".   Essentially all of this is documented
in Documentation/shared-subtress.txt.  Although frankly I have yet to
find a case where I really want shared subtreess.  Though I have found
a few cases where because we have to deal with sharing I using sharing
to make it not a pain.

Ultimately this means is that in every mount namespace that is created
we have to turn off sharing if we don't want it.    Which usually we
don't because mount namespaces are used when complete sharing is
undesirable.

Eric
