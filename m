Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaENQHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:07:00 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:33294 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaENQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <1400055532-13134-2-git-send-email-superlibj8301@gmail.com>
References: <1400055532-13134-1-git-send-email-superlibj8301@gmail.com>
	<1400055532-13134-2-git-send-email-superlibj8301@gmail.com>
Date: Wed, 14 May 2014 11:06:57 -0500
Message-ID: <CAL_JsqLncBaJ=uceovX80U1JPU8SW3KWKXW3PiVR8Kbnykcvpg@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] mm/vmalloc: Add IO mapping space reused interface support.
From: Rob Herring <robherring2@gmail.com>
To: Richard Lee <superlibj8301@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Laura Abbott <lauraa@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>, d.hatayama@jp.fujitsu.com,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Nico...

On Wed, May 14, 2014 at 3:18 AM, Richard Lee <superlibj8301@gmail.com> wrote:
> For the IO mapping, the same physical address space maybe
> mapped more than one time, for example, in some SoCs:
>   - 0x20001000 ~ 0x20001400 --> 1KB for Dev1
>   - 0x20001400 ~ 0x20001800 --> 1KB for Dev2
>   and the page size is 4KB.
>
> Then both Dev1 and Dev2 will do ioremap operations, and the IO
> vmalloc area's virtual address will be aligned down to 4KB, and
> the size will be aligned up to 4KB. That's to say, only one
> 4KB size's vmalloc area could contain Dev1 and Dev2 IO mapping area
> at the same time.
>
> For this case, we can ioremap only one time, and the later ioremap
> operation will just return the exist vmalloc area.

We already have similar reuse tracking for the static mappings on ARM.
I'm wondering if either that can be reused for ioremap as well or this
can replace the static mapping tracking. It seems silly to have 2
lists to search for finding an existing mapping.

But there is a fundamental problem with your approach. You do not and
cannot check the memory type of the mapping. If you look at the static
mapping code, it only reuses mappings if the memory type match. While
having aliases with different memory types is bad on ARMv6+, I assume
there are some cases that do that given the static mapping code
handles that case. We would at least want to detect and warn if we
didn't want to allow different attributes rather than just return a
mapping with whatever attributes the first mapping used.

Rob
