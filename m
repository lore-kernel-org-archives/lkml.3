Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbaJGXfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:35:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55646 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaJGXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:35:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Vagin <avagin@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
	<20141007132431.GF7996@ZenIV.linux.org.uk>
	<20141007134011.GA569@paralelels.com>
	<87vbnv3cl1.fsf_-_@x220.int.ebiederm.org>
	<20141007195307.GA23694@paralelels.com>
	<87iojvvbqe.fsf@x220.int.ebiederm.org>
	<20141007215959.GA4622@paralelels.com>
Date: Tue, 07 Oct 2014 16:35:10 -0700
In-Reply-To: <20141007215959.GA4622@paralelels.com> (Andrew Vagin's message of
	"Wed, 8 Oct 2014 02:00:00 +0400")
Message-ID: <878ukrmp1t.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18KQho7xytHOoPOu1kEFDJmEneT53tl5Q8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2042]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Vagin <avagin@parallels.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 275 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.3 (1.2%), b_tie_ro: 2.3 (0.8%), parse: 0.73 (0.3%),
	extract_message_metadata: 12 (4.4%), get_uri_detail_list: 1.29 (0.5%),
	tests_pri_-1000: 4.7 (1.7%), tests_pri_-950: 1.25 (0.5%), tests_pri_-900:
	1.02 (0.4%), tests_pri_-400: 20 (7.4%), check_bayes: 19 (7.0%), b_tokenize:
	4.8 (1.8%), b_tok_get_all: 9 (3.1%), b_comp_prob: 1.90 (0.7%),
	b_tok_touch_all: 2.0 (0.7%), b_finish: 0.65 (0.2%), tests_pri_0: 224 (81.7%),
	tests_pri_500: 3.9 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] umount:  Do not allow unmounting rootfs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Vagin <avagin@parallels.com> writes:

> On Tue, Oct 07, 2014 at 01:58:01PM -0700, Eric W. Biederman wrote:
>> Andrew Vagin <avagin@parallels.com> writes:
>> 
>> > On Tue, Oct 07, 2014 at 12:27:06PM -0700, Eric W. Biederman wrote:
>> >> 
>> >> Which in practice is totally uninteresting.  Only the global root user can
>> >> do it, and it is just a stupid thing to do.
>> >> 
>> >> However that is no excuse to allow a silly way to oops the kernel.
>> >> 
>> >> We can avoid this silly problem by setting MNT_LOCKED on the rootfs
>> >> mount point and thus avoid needing any special cases in the unmount
>> >> code.
>> >
>> > I had this idea too, but it doesn't work.
>> >
>> > MNT_LOCKED isn't inherited, if the privileged user creates a new mount
>> > namespace.
>> >
>> > So "unshame -m ./nsenter" reproduces the same BUG.
>> 
>> Which broken tree do you have where MNT_LOCKED is not inherited?
>
> It is Linus' tree with your patch.
>
> I commented out one line and the BUG isn't triggered any more.

Ok.  That is very very weird.  It works for me and not for you.

Doh!  I ran your test program first on the primary mount namespace
and didn't have /proc mounted when I tried to run your test program
later.

Thanks for the hint about copy_tree that does seem to be where the logic
goes haywire.  In copy_mnt_ns we want an exact copy not a partial copy.
The good news is that this bug could only affect rootfs, so it is not a
security hole with respect to mount namespaces, created with user
namespace permissions.

mount --rbind and mount propogation should not be locked to their parent
mounts so we do need to clear MNT_LOCKED in a few places.

A patch that fixes copy_tree carefully in a moment.

Eric
