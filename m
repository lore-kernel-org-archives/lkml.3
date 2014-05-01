Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaEAOOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:14:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33903 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaEAOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:14:43 -0400
Message-ID: <536256EC.1060909@windriver.com>
Date: Thu, 1 May 2014 10:15:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Daniel Bristot de Oliveira <bristot@redhat.com>,
        <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH RT] netconsole: enable netconsole on PREEMPT_RT
References: <31fa5b74f8e6267f9b7f906c791d1ddf7d550771.1398788759.git.bristot@redhat.com>
In-Reply-To: <31fa5b74f8e6267f9b7f906c791d1ddf7d550771.1398788759.git.bristot@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-29 01:55 PM, Daniel Bristot de Oliveira wrote:
> Dear RT Folks,
> 
> This patch enables the netconsole on PREEMPT_RT_FULL, netconsole
> was disabled on commit:
> cb7cb77 kconfig-disable-a-few-options-rt.patch
> 
> I tested the netconsole on three machines:
> 
> - Intel Core i5 (4 cpus) - Local network
> - Intel Xeon (32 cpus)   - Remote network
> - KVM VM (on a Core i7)  - Virtual network

Chances are the two real targets above were using the
same igb network driver.  I wonder if it matters what
underlying nic is used for netconsole?

It is probably worthwhile to do some data mining into why
it was disabled in the 1st place.  I can't say I recall, and
it is possible that the reason has long since become irrelevant,
even though the patch has been carried forward over time.

Or it may be that your testing simply doesn't cover the use
case where netconsole will spew sleeping while atomic...

P.
--

> 
> On these machines I build the kernel 3.10.34-rt34 + netconsole
> built as module. In order to execute some printks, I run a small
> benchmark that runs as a module. To analyse the output I captured
> the netconsole messages using Wireshark.
> 
> On all cases, the tests passed without any error:
> 
> - No error messages from the kernel
> - No missed messages
> - No out of order messages
> 
> I ran +1 hour tests on each machine. The test using the Xeon machine
> ran by around 10 hours. On this test I received 317149 netconsole's
> messages.
> 
> I also read the code and ran some traces (using the ftrace's
> function_graph). In the traces that I read, the netconsole code never
> broke the rt lock assumptions.
> 
> Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
> ---
>  drivers/net/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 096de88..3835321 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -164,7 +164,6 @@ config VXLAN
>  
>  config NETCONSOLE
>  	tristate "Network console logging support"
> -	depends on !PREEMPT_RT_FULL
>  	---help---
>  	If you want to log kernel messages over the network, enable this.
>  	See <file:Documentation/networking/netconsole.txt> for details.
> 
