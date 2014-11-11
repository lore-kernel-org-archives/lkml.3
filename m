Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaKKVQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:16:55 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:40520 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKKVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:16:53 -0500
Message-ID: <54627CBF.2000704@de.ibm.com>
Date: Tue, 11 Nov 2014 22:16:47 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: compiler bug gcc4.6/4.7 with ACCESS_ONCE and workarounds
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com> <54611D86.4040306@de.ibm.com> <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
In-Reply-To: <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111121-0041-0000-0000-00000213CAD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.11.2014 um 22:07 schrieb Linus Torvalds:
> On Mon, Nov 10, 2014 at 12:18 PM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>>
>> Now: I can reproduces belows miscompile on gcc46 and gcc 47
>> gcc 45 seems ok, gcc 48 is fixed.  This makes blacklisting
>> a bit hard, especially since it is not limited to s390, but
>> covers all architectures.
>> In essence ACCESS_ONCE will not work reliably on aggregate
>> types with gcc 4.6 and gcc 4.7.
>> In Linux we seem to use ACCESS_ONCE mostly on scalar types,
>> below code is an example were we dont - and break.
> 
> Hmm. I think we should see how painful it would be to make it a rule
> that ACCESS_ONCE() only works on scalar types.
> 
> Even in the actual code you show as an example, the "fix" is really to
> use the "unsigned long val" member of the union for the ACCESS_ONCE().
> And that seems to be true in many other cases too.

Yes, using the val like in 
-               new = old = ACCESS_ONCE(*ic);
+               new.val = old.val = ACCESS_ONCE(ic->val);

does solve the problem as well. In fact, gcc does create the same binary
code on my 4.7.2.

Are you ok with the patch as is in kvm/next for the time being or shall
we revert that and replace it with the .val scheme?

We can also do the cleanup later on if we manage to get your initial patch
into a shape that works out.

Christian

