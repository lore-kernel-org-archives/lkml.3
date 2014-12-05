Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLEO77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:59:59 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:58016 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbaLEO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:59:58 -0500
Message-ID: <1417791592.2232.5.camel@linaro.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 05 Dec 2014 14:59:52 +0000
In-Reply-To: <1417774227.2232.1.camel@linaro.org>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
	 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
	 <1417710073.2239.10.camel@linaro.org> <5481289E.4060504@huawei.com>
	 <1417774227.2232.1.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 10:10 +0000, Jon Medhurst (Tixy) wrote:
[...]
> I'm worried because this whole optimised kprobes has some rather
> complicated interactions, e.g. can the background thread that changes
> breakpoints to jumps (or back again?) could occur at the same time
> another CPU is processing a kprobe that's been hit, or is in the process
> of removing a probe.

I think that is a plausible theory. We can have this situation...

1. CPU A executes a probe's 'breakpoint' instruction and the undefined
instruction exception handler is triggered.

2. CPU B is executing the kprobes optimisation thread and replaces the
'breakpoint' with a branch instruction.

3. CPU A reads the invalid instruction from memory and because this is
now the branch instruction it doesn't match
KPROBE_ARM_BREAKPOINT_INSTRUCTION which kprobes registered to handle.
This means the undefined instruction exception is treated as just that,
execution of an undefined instruction.

The above scenario is the exact reason why arch_disarm_kprobe is
implemented to always use stop_machine to modify the code and we need to
ensure the same happens with arch_optimize_kprobes.

-- 
Tixy


