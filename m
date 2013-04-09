Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936000Ab3DIVQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:16:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39451 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864Ab3DIVQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:16:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
	<20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
	<87ip3w59gr.fsf@xmission.com> <1790080.52kjZ1ec4G@x2>
Date: Tue, 09 Apr 2013 14:16:22 -0700
In-Reply-To: <1790080.52kjZ1ec4G@x2> (Steve Grubb's message of "Tue, 09 Apr
	2013 16:39:46 -0400")
Message-ID: <87vc7v1k2h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Rnv4LTWmpwMJKnohV/vJoBWMCEKDZ14I=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steve Grubb <sgrubb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in audit rules and data
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Grubb <sgrubb@redhat.com> writes:

> On Tuesday, April 09, 2013 02:39:32 AM Eric W. Biederman wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> > On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> 
> wrote:
>> >> audit rule additions containing "-F auid!=4294967295" were failing with
>> >> EINVAL.
>> >> 
>> >> UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting
>> >> and
>> >> testing against audit rules.  Remove the check for invalid uid and gid
>> >> when
>> >> parsing rules and data for logging.
>> 
>> In general testing against invalid uid appears completely bogus, and
>> should always return true.  As it is and essentially always has been
>> incorrect to explicitly set any kernel uid to that value.
>
> This is the unset value that daemons would have. 

As their uid, or gid, or euid, or fsuid.  Not in the least.

> When a real person logs in, 
> pam_loginuid writes the loginuid that was authenticated to. So, any time the 
> value is -1, we are dealing with a daemon or system process. When it comes to 
> auditing, people usually make an exception so that daemon and normal system 
> activity is not recorded. So, you would make a rule something like

> -a always,exit -S open -F exit=-EPERM -F auid>=500 -F auid!=-1

My point is that -1 is a special case that applies only to loginuid, and
that when testing for -1 is not testing for a specific loginuid value
but instead it is testing to see if loginuid has been set.  Semantically
the last is very different.

>> The only case where this appears to make the least little bit of sense
>> is if the goal of the test is to test to see if an audit logloginuid
>> has been set at all.  In which case depending on a test against
>> 4294967295 is bogus because you are depending on an intimate internal
>> kernel implementation detail.
>
> Its been this way and documented since at least 9 years ago. The audit system 
> has been broken for all intents and purposes since the 3.7 kernel was 
> released.

I certainly haven't seen the documentation.  And no one has much cared
about the audit subsystem this "breakage" of the audit
subsystem. Despite things failing with a clear error code.  So there are
two choices.  We mark the audit subsystem as broken moving it to staging
and then delete it because no one cares enough to look after it and
maintain it.  Or we have a constructive conversation about what to do
with it.

I have proposed a patch that will preserve the existing behavior while
adding maintainable semantics.  Will someone who cares please test my
proposed fix?

Eric
