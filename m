Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaFXIXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:23:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62702 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFXIXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:23:04 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-61-53a935628ac5
Message-id: <53A9342D.3060400@samsung.com>
Date: Tue, 24 Jun 2014 12:17:49 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, tetra2005@gmail.com, preobr@google.com,
        dvyukov@google.com, kcc@google.com, koct9i@gmail.com
Subject: Re: [PATCH] lib: idr: fix out-of-bounds pointer dereference
References: <1403530628-32306-1-git-send-email-a.ryabinin@samsung.com>
 <53A8D3B0.8090004@cn.fujitsu.com> <53A91125.8020203@samsung.com>
 <53A92D50.3050507@cn.fujitsu.com>
In-reply-to: <53A92D50.3050507@cn.fujitsu.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xq7pJpiuDDVZ3mFvMWb+GzWLCwzZ2
	i+3P3jJZrOx8wGqxYnUbq8XlXXPYLPatPM9k8e7ZZGaLX8uPMjpwevw/OInZY+esu+weCzaV
	emxa1cnmcWLGbxaPz5vkAtiiuGxSUnMyy1KL9O0SuDJ2PDzEUvCUq6Jj93vmBsaDHF2MnBwS
	AiYSvVfPsEHYYhIX7q0Hsrk4hASWMkr8e7iZHSQhJNDMJDH/jEQXIwcHr4CWxJFVmiAmi4Cq
	xJ3/4SAVbAJ6Ev9mbQcbIyoQIXGg7xkriM0rICjxY/I9FpByEQENiStHwkCmMwucYJRY+msa
	K0hcWMBF4s/aZIhFaxklzn/WBbE5gUbeb7gLNpJZQF1i0rxFzBC2vMTmNW+ZJzAKzEKyYRaS
	sllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAn9rzsYlx6zOsQowMGoxMNbsWNF
	sBBrYllxZe4hRgkOZiUR3mK1lcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOMjee2mdSypXMD3
	/HTM+xe/WWTOn18yZ4aL59td7bpf+QOELRV3ehw/PsfAMXfXyuBi34q877ZlPLEid97M85k/
	P7I4NtfSw2niXfukJ61m05e92ihYw2p+NmnZubb9oU9rNCbeNp7dyjP5ZneT4FwJR1nbya17
	9t+bfFvkQuQZ4atPFjEttlNiKc5INNRiLipOBACali5QWwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/14 11:48, Lai Jiangshan wrote:
> 
> 326cf0f0f308 ("idr: fix top layer handling") enlarged the pa array.
> But the additional "+1" space is only used in id-allocation, it is free
> in other usage, (paa may point to the additional "+1" space, but not dereference it).
> so you can reuse it.
> 
> In the 3 functions your patch touched:
> -	struct idr_layer ***paa = &pa[0];
> +	struct idr_layer ***paa = &pa[1];
> 

Yeah, I thought about such change, but decided this will look very confusing.
Though, this could be made less confusing with good comment why we are assigning
pointer to second element.
I'm think that we should also initialize pa[0] in such case, to avoid possible kmemchek's report
about uninitialized memory read.

> 
> I don't reject your patch, I had review it.
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The reason why I'm still muttering here is that I wish a simple solution
> to fix the problem. And:
> 1) your patch also makes use of the additional "+1" @pa space: *++paa = p
> 2) your patch may slight enlarge the function body.
> 3) I think you patch reduces the readability a little although the idr code
>    itself is already shit.
> 

I have no strong opinion about what change is better. They both looks shitty to me.
The best solution here would be to rewrite this whole code from scratch.

