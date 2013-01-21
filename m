Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3AUABL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:01:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51382 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3AUABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:01:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Carlos O'Donell" <carlos@systemhalted.org>
Cc: Eric Paris <eparis@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
References: <1357747463.2593.28.camel@localhost>
	<1357760637.2593.55.camel@localhost>
	<50EDCFC0.3010401@schaufler-ca.com>
	<1357763560.1342.7.camel@localhost> <50EDD8D4.60003@schaufler-ca.com>
	<20130109205947.GE26036@sunsite.ms.mff.cuni.cz>
	<1357765795.1342.21.camel@localhost>
	<50EDEC85.5060802@systemhalted.org>
Date: Sun, 20 Jan 2013 16:00:46 -0800
In-Reply-To: <50EDEC85.5060802@systemhalted.org> (Carlos O'Donell's message of
	"Wed, 09 Jan 2013 17:17:41 -0500")
Message-ID: <871udfmmkx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+SMGpI9uQxX+Y30flAlJ6chCNUC1IwFXQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4998]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Carlos O'Donell <carlos@systemhalted.org>
X-Spam-Relay-Country: 
Subject: Re: Friendlier EPERM - Request for input
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos O'Donell <carlos@systemhalted.org> writes:

> On 01/09/2013 04:09 PM, Eric Paris wrote:
>> On Wed, 2013-01-09 at 21:59 +0100, Jakub Jelinek wrote:
>>> On Wed, Jan 09, 2013 at 12:53:40PM -0800, Casey Schaufler wrote:
>>>> I'm suggesting that the string returned by get_extended_error_info()
>>>> ought to be the audit record the system call would generate, regardless
>>>> of whether the audit system would emit it or not.
>>>
>>> What system call would that info be for and would it be reset on next
>>> syscall that succeeded, or also failed?
>>>
>>> The thing is, various functions e.g. perform some syscall, save errno, do
>>> some other syscall, and if they decide that the first syscall should be what
>>> determines the whole function's errno, just restore errno from the saved
>>> value and return.  Similarly, various functions just set errno upon
>>> detecting some error condition in userspace.
>>> There is no 1:1 mapping between many libc library calls and syscalls.
>>> So, when would it be safe to call this new get_extended_error_info function
>>> and how to determine to which syscall it was relevant?
>
> I asked the same questions as Jakub asked but in a slightly different
> formulation (http://cygwin.com/ml/libc-alpha/2013-01/msg00267.html).
>  
>> I was thinking of it to be the last kernel error.  So if the first and
>> that second operation caused the kernel to want to make available
>> extended errno information you would end up with the second.  I see this
>> is an informative piece of information, not normative.  Not a
>> replacement for errno.  I'm hoping for a best effort way to provide
>> extended errno information.
>
> IMO Casey's answer is the right solution i.e. whatever the errno
> behaviour was.

Let me propose a different mechanism for getting this to user space
that gives you a save/restore ability.

When a system call returns with an error we return the error code
in one register and leave the rest of the registers that calling
conventions allow us to stomp unchanged.

On i386 (probabaly our most constraint architecture) that gives us
4 32bit registers or 16 bytes/characters to play with.

Returning either an exteneded error number or a short
string in those extra bytes should be very doable, and largely
backwards compatible.

Then in userspace for those applications who care you can
have a "struct exteneded_error" that holds the extra information.

To use that information I expect you want something like:

char *explain_error(int (*failed_func)(...), int errno, struct extended_error *error);

Where explain_error could possibly deduce things even if there
is no side channel information in the kernel. (i.e. You got EPERM
because the permissions are 0700 and you don't own the file.)

Having the core information returned in registers (that are saved by
signal handling) and having a structure of a fixed size that you can
save and restore should help.

Eric
