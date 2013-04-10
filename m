Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641Ab3DJSdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:33:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59488 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3DJSdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:33:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
	<20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
	<87ip3w59gr.fsf@xmission.com>
	<20130409201558.GE31242@madcap2.tricolour.ca>
Date: Wed, 10 Apr 2013 11:02:43 -0700
In-Reply-To: <20130409201558.GE31242@madcap2.tricolour.ca> (Richard Guy
	Briggs's message of "Tue, 9 Apr 2013 16:15:58 -0400")
Message-ID: <871uaiz2kc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18DsJlS4JIrHnZe5h1trzICTOjXqWElFTo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 XM_Evil_Numbers_Gen maybe a phone number spam
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in audit rules and data
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> On Tue, Apr 09, 2013 at 02:39:32AM -0700, Eric W. Biederman wrote:

>> @@ -377,6 +383,12 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
>>  			if (!gid_valid(f->gid))
>>  				goto exit_free;
>>  			break;
>> +		case AUDIT_LOGINUID_SET:
>> +			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
>> +				goto exit_free;
>> +			if ((f->val != 0) && (f->val != 1))
>
> Why the extra comparison to "1"?
>
> Are you anticipating already a userspace process making a call using the
> newof type AUDIT_LOGINUID_SET with a value of 1?

Sorry I missed this question the first time.  I am anticipating
AUDIT_LOGINUID_SET to return a value of 0 or 1 (a boolean) and so I
allow the operations and constants that are valid for a boolean.

In particuluar I allow the opeartions == !=  and the boolean constants 0 and 1.

>> @@ -1380,6 +1405,10 @@ static int audit_filter_user_rules(struct audit_krule *rule,
>>  			result = audit_uid_comparator(audit_get_loginuid(current),
>>  						  f->op, f->uid);
>>  			break;
>> +		case AUDIT_LOGINUID_SET:
>> +			result = audit_comparator(audit_loginuid_set(current),
>> +						  f->op, f->val);
>> +			break;
>>  		case AUDIT_SUBJ_USER:
>>  		case AUDIT_SUBJ_ROLE:
>>  		case AUDIT_SUBJ_TYPE:
>> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> index 3a11d34..27d0a50 100644
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@ -750,6 +750,9 @@ static int audit_filter_rules(struct task_struct *tsk,
>>  			if (ctx)
>>  				result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
>>  			break;
>> +		case AUDIT_LOGINUID_SET:
>> +			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
>> +			break;
>
> (OT: I assume the "if (ctx)" is wrong in the AUDIT_LOGINUID case
> above.)

Good question.  I didn't see that when I was preparing my patch.

ctx is not necessary but I think ctx is set when a task is being audited
so it may serve a useful function.  But I have to admit it that if(ctx)
looks like a bug.

Eric
