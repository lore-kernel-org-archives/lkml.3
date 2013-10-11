Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3JKFt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:49:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49992 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3JKFtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:49:25 -0400
Message-ID: <52579160.1090800@gmail.com>
Date: Fri, 11 Oct 2013 16:49:20 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsprintf/sysctl: Bugfix, neaten and document %pK
 usages
References: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>	 <52578D37.2000004@gmail.com> <1381469910.14017.45.camel@joe-AO722>
In-Reply-To: <1381469910.14017.45.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 16:38, Joe Perches wrote:
> On Fri, 2013-10-11 at 16:31 +1100, Ryan Mallon wrote:
>> On 11/10/13 16:25, Joe Perches wrote:
>>> Printing kernel pointers via %pK has a minor defect when
>>> kptr_restrict is set to 2:  the pointer may be emitted
>>> as "pK-error" instead of all 0's when in an interrupt.
>>
>> NAK. This is not a defect, as I explained earlier. It is really a defect
>> that it _doesn't_ print 'pK-error' in all cases. 'pK-error' is for
>> finding kernel bugs.
> 
> Not my understanding.
> 
> There is no bug to find when emitting a pointer via %pK.

Yes there is. %pK is not valid from interrupt context, because the
current way it is checked is by checking CAP_SYSLOG. It is irrelevant
that this check is only done when kptr_restrict=1, using %pK from
interrupt handlers is still wrong. We want to notify developers of any
wrong cases.

> 
> The only issue is that has_capability_noaudit can not
> be called from an interrupt.

Right. So any code that uses %pK from interrupt context would be, by
definition, broken. That is what the check is looking for.

It doesn't matter what the value of kptr_restrict happens to be, the
code is still broken. So, with your patch, values 0 and 2 of
kptr_restrict will print a seemingly correct value, but when
kptr_restrict is 1 then it will print 'pK-error'.

That is confusing to users: file prints correct pointer values when
kptr_restrict=0; file prints 'pK-error' when kptr_restrict=1, even
though I am root. Also, because the default is now kptr_restrict=0, less
people will see the 'pK-error' value, so buggy code may go over-looked.

It should print 'pK-error' in all cases, so that any bugs where %pK is
being used from interrupt content are identified regardless of the
setting of kptr_restrict.

Anyway, with the approach that Eric and George suggested, this would
become a non-issue. So probably just best to leave the code as is.

~Ryan

