Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaIXEL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:11:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44541 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:11:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Graf <tgraf@suug.ch>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, john.r.fastabend@intel.com,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1410782841.git.tgraf@suug.ch>
	<bd3aa4282e89b022620225101ab491e344852f5f.1410782841.git.tgraf@suug.ch>
	<1410784535.7106.164.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140915124937.GB21541@casper.infradead.org>
Date: Tue, 23 Sep 2014 21:11:31 -0700
In-Reply-To: <20140915124937.GB21541@casper.infradead.org> (Thomas Graf's
	message of "Mon, 15 Sep 2014 13:49:37 +0100")
Message-ID: <87sijhwtcc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19S8vdg3XVuruZVyPNTzVvlI3dFMLVJMbY=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1359]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Thomas Graf <tgraf@suug.ch>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/5] rhashtable: Remove gfp_flags from insert and remove functions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Graf <tgraf@suug.ch> writes:

> On 09/15/14 at 05:35am, Eric Dumazet wrote:
>> On Mon, 2014-09-15 at 14:18 +0200, Thomas Graf wrote:
>> > As the expansion/shrinking is moved to a worker thread, no allocations
>> > will be performed anymore.
>> > 
>> 
>> You meant : no GFP_ATOMIC allocations ?
>> 
>> I would rephrase using something like :
>> 
>> Because hash resizes are potentially time consuming, they'll be
>> performed in process context where GFP_KERNEL allocations are preferred.
>
> I meant to say no allocations in insert/remove anymore but your wording
> is even clearer. I'll update it.
>
>> > -	tbl = kzalloc(size, flags);
>> > +	tbl = kzalloc(size, GFP_KERNEL);
>> 
>> Add __GFP_NOWARN, as you fallback to vzalloc ?
>
> Good point.

It needs to be both __GFP_NOWARN and __GFP_NORETRY.

Otherwise the system will kick in the OOM killer before it falls back to
vzalloc.  Which I can't imagine anyone wanting.

Look at the history of alloc_fdmem in fs/file.c for the real world
reasoning.

Eric
