Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaJTN6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:58:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46930 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaJTN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:58:30 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-cf-5445150396cd
Message-id: <54451501.2070700@samsung.com>
Date: Mon, 20 Oct 2014 17:58:25 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.1
MIME-version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org>
In-reply-to: <20141020124929.GA23177@thunk.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4NV1mUdcQg0l7RSy+fulgsZizfg2b
	xYSHbewW0zaKW6zsfMBq8WfXDiaLy7vmsFlcOrCAyaJl3wUmi+O9B5gsFh+5zWyxedNUZovW
	np/sFj82PGZ14PNo2VzusXPWXXaPBZtKPTav0PLYtKqTzePduXPsHidm/GbxaDpzlNnj49Nb
	LB7v911l8ziz4Ai7x+dNch4nWr6wBvBGcdmkpOZklqUW6dslcGWcW7uWueAKT8WE1dwNjG84
	uxg5OSQETCQOf3/HBmGLSVy4tx7I5uIQEljKKPF663RGCKeZSeJC9xRGkCpeAS2JO9+WgNks
	AqoSU7ovM4HYbAJ6Ev9mbQebJCoQIbFx/Q6oekGJH5PvsYDYIgKKErdavjCDDGUWuMQscWn2
	SbCEsICLxKl7j9ghtnUxSjw9vI0ZJMEpoC/Rtfs22AZmAR2J/a3T2CBseYnNa94yT2AUmIVk
	ySwkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJ3X3cwLj1mdYhRgINRiYd3
	h5lLiBBrYllxZe4hRgkOZiUR3lOCriFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGHftz86fGP9V
	13Kze84Gd5+je6eZGs+P+JTYZjxzAyvX1QsJz84ccpbtbCw0m7hUZz1r2z2BJZMmaTdvaxFK
	Z0hv+Hkz9F+DXrYCj/KNV1m579Nczulb3DkVlPkgfXJDkMPTHbInzYPXb6rTurT+836z33cm
	nbbMT/ZdG6yUbKo26/2T3KyzrEosxRmJhlrMRcWJABWfjSSZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 04:49 PM, Theodore Ts'o wrote:
> On Mon, Oct 20, 2014 at 03:03:22PM +0400, Andrey Ryabinin wrote:
>> Hi, Theodore.
>>
>> I've got this while booting kernel with ubsan:
>>
>>     [    0.000000] ================================================================================
>>     [    0.000000] UBSan: Undefined behaviour in ../include/linux/bitops.h:107:33
>>     [    0.000000] shift exponent 32 is to large for 32-bit type 'unsigned int'
>       ...
>>     [    0.000000] _mix_pool_bytes (/home/andrew/linux/ubsan_x86//include/linux/bitopsh:107 /home/andrew/linux/ubsan_x86//drivers/char/randomc:509)
> 
> So this doesn't make any sense to me.   This is triggering here:
> 
> 	w = rol32(*bytes++, input_rotate);
> 
> .... but input_rotate should never be >= 32, since it is set this way:
> 

It's triggering when input_rotate == 0, so UBSan complains about right shift in rol32()

static inline __u32 rol32(__u32 word, unsigned int shift)
{
	return (word << shift) | (word >> (32 - shift));
}


> 	input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
> 
> Just to be sure I've tried adding a:
> 
> 	WARN_ON(input_rotate >= 32);
> 
> before the rol32 line, and it's not triggering for me after booting
> under kvm using an i386 kernel.
> 
> Is this something you can reliably reproduce?  Can you try putting a
> WARN_ON before the rol32() on a kernel w/o usbsan, just to make sure
> this isn't some kind of false positive?  And then can you tell me
> something more about the .config you are using to build your test kernel?
> 
> Thanks,
> 
> 						- Ted
> 

