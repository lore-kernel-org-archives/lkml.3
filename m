Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3EaGxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:53:47 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:42246 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3EaGxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:53:41 -0400
Message-ID: <51A848F1.3040301@ladisch.de>
Date: Fri, 31 May 2013 08:53:37 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Timur Tabi <timur.tabi@calxeda.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2] ata: increase retry count but shorten duration for
 Calxeda controller
References: <1369923509-3246-1-git-send-email-mark.langsdorf@calxeda.com> <51A76197.9080708@calxeda.com> <51A7646B.6080203@cogentembedded.com>
In-Reply-To: <51A7646B.6080203@cogentembedded.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> On 30-05-2013 18:26, Timur Tabi wrote:
>>> +    const unsigned long timing[] = { 5, 100, 500};
>
>> You'll save space and time if you also make this array "static",
>> otherwise the compiler will build the array every time this function is
>> called.
>
> No, *const* specifier is enough to not build this array every time. It will be put into the .const section.

gcc disagrees:

$ cat const_static.c
int f(int x) {
	const unsigned long timing[] = { 5, 100, 500};
	static const unsigned long timing2[] = { 5, 100, 500};
	return timing[x] + timing2[x];
}
$ gcc -Os -S const_static.c
$ cat const_static.s
	...
timing2.0:
        .long   5
        .long   100
        .long   500
	...
        movl    8(%ebp), %edx
        movl    $5, -16(%ebp)
        movl    $100, -12(%ebp)
        movl    $500, -8(%ebp)
        movl    timing2.0(,%edx,4), %eax
        addl    -16(%ebp,%edx,4), %eax


Regards,
Clemens
