Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbaFUAUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 20:20:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60094 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaFUAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 20:20:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Willy Tarreau <w@1wt.eu>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, tyler.hicks@canonical.com
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
	<20140512003203.088027167@1wt.eu> <20140611184644.GA5442@hercules>
	<20140611194657.GU28551@1wt.eu> <87sinanv6u.fsf@canonical.com>
	<20140614175047.GH15102@1wt.eu> <87simzgrbs.fsf@x220.int.ebiederm.org>
	<20140620225827.GF9639@1wt.eu>
Date: Fri, 20 Jun 2014 17:19:15 -0700
In-Reply-To: <20140620225827.GF9639@1wt.eu> (Willy Tarreau's message of "Sat,
	21 Jun 2014 00:58:27 +0200")
Message-ID: <87y4wrf724.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ZDZTStQf170G/gfQws2H3omM5quFS8kE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3771]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Willy Tarreau <w@1wt.eu>
X-Spam-Relay-Country: 
Subject: Re: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> Hi Eric,
>
> On Fri, Jun 20, 2014 at 03:16:07PM -0700, Eric W. Biederman wrote:
>> Willy Tarreau <w@1wt.eu> writes:
>> 
>> > Hi Luis,
>> >
>> > On Thu, Jun 12, 2014 at 01:55:53PM +0100, Luis Henriques wrote:
>> >> I was finally able to spend some more time with this and tried (a
>> >> modified) Tyler's patch on top of 2.6.32.62, and it seems to work.
>> >> Although I haven't done any extended testing, I don't see the two
>> >> stack traces and the /proc/sys/net/ipv4/ directory seems to be
>> >> correctly populated.
>> >> 
>> >> I'm attaching the patch I've used, based on Tyler's.
>> >
>> > Would any of you or Tyler please kindly pass me a signed-off-by with
>> > a commit message ? That would be great. Alternately I'd do it myself
>> > and mention you authored them.
>> 
>> If my memory serves it is possibe in 2.6.32 to set 
>> .ctl_name = CTL_UNNEEDED
>> 
>> and not need to implement a .strategy routine at all.
>
> Ah that's quite interesting, thanks for the tip!
>
>> Given the fact that most people got the strategy routines
>> slightly wrong and that sys_sysctl is effectively unused
>> a strategy where you don't implement code that no-one
>> will use in a backport I would be preferable.
>
> OK.
>
>> Since you have mentioned this has come up a couple of times if something
>> else this will be something to think about for next time.
>
> I'm keeping your e-mail where I manage patches, hoping to recognize
> this case next time.
>
>> I am puzzled why .ctl_name was populated in a backport at all.
>
> Oh it's simply because I didn't know it did not have to be there,
> and among the few reviewers, I guess that it's not common to know
> what version uses what semantics.

I guess what I meant is that the field .ctl_name does not even exist
anymore for the same reasons .strategy does not exist anymore.  So I
was just suprirsed that someone picked a randomish number and stuck
it in there.

If anyone actually were to use those randomish numbers in the binary
sys_sysctl call their applications would break when they eventually
moved to a more recent kernel.

Which is one of the motivations it was decided there would be no more
binary sysctls allocated around the 2.6.32 timeframe.

> Thank you for the exaplanation, it's really helpful. We're not used
> to backport sysctl changes but here I got caught a few times and have
> found some sysctl.conf with bogus values in field a few times, so it
> was really important to backport this one.

Sysctl do have their uses, and at least 2.6.32 has runtime sysctl checks
to keep the insanity to a dull roar.

Eric
