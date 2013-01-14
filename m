Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3ANKJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:09:42 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:46347 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3ANKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:09:40 -0500
Message-ID: <50F3D951.4070503@synopsys.com>
Date: Mon, 14 Jan 2013 15:39:21 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: James Hogan <james.hogan@imgtec.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: early init dt for earlyprintk (was Re: [RFC PATCH v1 25/31] ARC:
 [plat-arcfpga] Hooking up platform to ARC UART)
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-26-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de> <50F3B54D.7010801@synopsys.com> <50F3D481.4000806@imgtec.com>
In-Reply-To: <50F3D481.4000806@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013 03:18 PM, James Hogan wrote:
> Hi Vineet
> 
> On 14/01/13 07:35, Vineet Gupta wrote:
>> 2. We really need a Documentation/dt-for-new-linux-arches.txt, as the existing
>> refs - while very helpful - fail to mention subtleties such as you absolutely need
>> a intc instance and a default irq domain ..... before the driver can start using
>> the DT.
> 
> Sounds like a good idea. I'm curious about what you say about default
> IRQ domains though. Do you mean irq_set_default_host? In what way is
> that required to use DT?
> 
> Cheers
> James
> 

Nope, the fact that we need a irq_domain_add_*( ) call corresponding to atleast
one interrupt-controller node in the DT. In absence of that, the following
callstack returns - with RESOURCE_IRQ unpopulated - causing driver to eventually
fail the probe.

of_platform_populate
...
   of_irq_to_resource
      irq_of_parse_and_map
        irq_create_of_mapping  -> Needs "some" irq domain.

Prior to introducing DT in ARC Port, I didn't have any of CONFIG_IRQ_DOMAIN and
still it used to work fine. Enabling CONFIG_OF forced me to enable
CONFIG_IRQ_DOMAIN (merely to resolve link errors) but I had no clue (call me
stupid if you will) that I needed an actual domain setup.

The irq_set_default_host( ) is a nice design pattern though which avoids exporting
the root domain outside of the specific compilation unit.

-Vineet
