Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaHTEJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:09:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33442 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaHTEJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:09:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, serge@hallyn.com, linux-api@vger.kernel.org
References: <cover.1400271129.git.rgb@redhat.com>
	<1400593754.15733.4.camel@flatline.rdu.redhat.com>
	<20140520140146.GA8079@madcap2.tricolour.ca>
	<20140819164617.GE9003@madcap2.tricolour.ca>
Date: Tue, 19 Aug 2014 21:04:57 -0700
In-Reply-To: <20140819164617.GE9003@madcap2.tricolour.ca> (Richard Guy
	Briggs's message of "Tue, 19 Aug 2014 12:46:17 -0400")
Message-ID: <8738crst5i.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18zZkj9mBuhnmwY/fPUxwSjxc0ZM2VQm2U=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> On 14/05/20, Richard Guy Briggs wrote:
>> On 14/05/20, Eric Paris wrote:
>> > On Tue, 2014-05-20 at 09:12 -0400, Richard Guy Briggs wrote:
>> > > The purpose is to track namespaces in use by logged processes from the
>> > > perspective of init_*_ns.
>
> (Including the Linux API list due to the additions to /proc/<pid>/ns/.
> Please see http://www.kernelhub.org/?p=2&msg=477668 and in particular
> http://www.kernelhub.org/?msg=477678&p=2 )

Sigh if you have to use something like this use the proc inode
number.  It is the same thing.

I hate to claim it is unique absent of the proc superblock but it is and
will be for the forseable future.  

It would be better to include the block device number that appears in
proc of 3h of the primary mount of to qualify the number.  But it is not
particularly important.  Coming up with an additional unique number that
needs to be maintained seems stronlgy silly.

Eric



> <snip>
>
>> > > 5/6 provides an example of usage for audit_log_task_info() which is used by
>> > > syscall audits, among others.  audit_log_task() and audit_common_recv_message()
>> > > would be other potential use cases.
>> > > 
>> > > Proposed output format:
>> > > This differs slightly from Aristeu's patch because of the label conflict with
>> > > "pid=" due to including it in existing records rather than it being a seperate
>> > > record.  The serial numbers are printed in hex.
>> > > 	type=SYSCALL msg=audit(1399651071.433:72): arch=c000003e syscall=272 success=yes exit=0 a0=40000000 a1=ffffffffffffffff a2=0 a3=22 items=0 ppid=1 pid=483 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="(t-daemon)" exe="/usr/lib/systemd/systemd" netns=97 utsns=2 ipcns=1 pidns=4 userns=3 mntns=5 subj=system_u:system_r:init_t:s0 key=(null)
>> > 
>> > I'm undecided if I'd rather see this as a separate NS_INFO record type.
>> > It would mean we could filter them out of the logs...
>> 
>> I don't have a strong opinion either way.  Steve G.'s opinion would be
>> helpful here.
>
> Breaking this out into a seperate record type would mean calling
> audit_log_namespace_info() from the callers of audit_log_task_info()
> (presently audit_log_link_denied(), ima_audit_measurement(),
> audit_log_exit() ), but would make it easier to emit with other record
> types.
>
>> > Do we print out lots of pidns=0 for tasks not in a newly created NS?  Do
>> > we want to?
>> 
>> There is no "pidns=0", but I understand your point.  This would come
>> back to Steve G.'s point about disappearing fields, and the value of
>> having it as a seperate record that could be filtered.
>> 
>> > > 6/6 tracks the creation and deletion of of namespaces, listing the type of
>> > > namespace instance, related namespace id if there is one and the newly minted
>> > > serial number.
>> > > 
>> > > Proposed output format:
>> > > 	type=NS_INIT msg=audit(1400217435.706:94): pid=524 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:mount_t:s0 type=20000 old_snum=0 snum=a1 res=1
>> > 
>> > I'd love to be able to grep for netns=20 and find both the NS_INIT and
>> > the SYSCALL/NS_INFO records, instead of having them named different
>> > things.  So basically I think you want to translate the type= into a
>> > string for the old_X= and X=...
>> 
>> That actually makes a bit more sense, and we could do away with the
>> "type=" field since the "Xns=" fields are self-describing.
>
> Steve, how do you feel about this since the NS_INIT/NS_DEL record type
> would have changing fields amongst the 6 namespace types.  Only one of
> the 6 would be present in each message.  I suppose we could have an
> NS_INIT_XXX/NS_DEL_XXX for each namespace type.
>
>> - RGB
>
> - RGB
>
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
