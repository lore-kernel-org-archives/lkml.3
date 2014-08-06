Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaHFTSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:18:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40367 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaHFTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:18:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk, ian.molton@codethink.co.uk
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>
	<20140806160259.GR18016@ZenIV.linux.org.uk>
	<53E254F1.30605@codethink.co.uk>
Date: Wed, 06 Aug 2014 12:14:51 -0700
In-Reply-To: <53E254F1.30605@codethink.co.uk> (Rob Jones's message of "Wed, 06
	Aug 2014 17:16:49 +0100")
Message-ID: <87sil9sa50.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+fCdBzzDUQ/iMaUDbp20N+BfATzsy3T7c=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4925]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Jones <rob.jones@codethink.co.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] seq_file: Allow private data to be supplied on seq_open
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Jones <rob.jones@codethink.co.uk> writes:

> On 06/08/14 17:02, Al Viro wrote:
>> On Tue, Jul 29, 2014 at 06:39:53PM +0100, Rob Jones wrote:
>>
>>> At the moment these consumers have to obtain the struct seq_file pointer
>>> (stored by seq_open() in file->private_data) and then store a pointer to
>>> their own data in the private field of the struct seq_file so that it
>>> can be accessed by the iterator functions.
>>>
>>> Although this is not a long piece of code it is unneccessary boilerplate.
>>
>> How many of those do we actually have?
>
> A quick grep (I didn't examine them all) showed what looked like at
> least 80 instances of the work around.

I took a quick look as well and what I saw was that if we were to
implement the helpers: seq_open_PDE_DATA, and seq_open_i_private.  That
would cover essentially all of seq_open that set seq_file->private.  So
my gut feel is that a seq_open_priv is the wrong helper.

In the vast majority of the cases either seq_open is good enough,
we want seq_open_private, or seq_file->private is set to PDE_DATA
or i_private.

I think there may be 5 cases in the kernel that do something different,
and those cases probably need a code audit.

>>> seq_open() remains in place and its behaviour remains unchanged so no
>>> existing code should be broken by this patch.
>>
>> I have no objections against such helper, but I's rather have it
>> implemented via seq_open() (and as a static inline, not an export),
>> not the other way round.  Oh, and conversion of at least some users would
>> be nice to have as well...

I have no significant objection but having both seq_open_private
and seq_open_priv seems confusing name wise.

Eric
