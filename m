Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3EaQpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:45:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34270 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3EaQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:45:14 -0400
Message-ID: <51A8D1D7.4000807@wwwdotorg.org>
Date: Fri, 31 May 2013 10:37:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Michal Marek <mmarek@suse.cz>, Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, JonLoeliger <jdl@jdl.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: DTB build failure due to preproccessing
References: <1369996170.5199.68.camel@zakaz.uk.xensource.com>
In-Reply-To: <1369996170.5199.68.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 04:29 AM, Ian Campbell wrote:
> This affects arch/powerpc/boot/dts/virtex440-ml510.dts but I think it is
> actually a more general issue:
> 
>         $ make ARCH=powerpc CROSS_COMPILE=powerpc-linux- virtex440-ml510.dtb 
>           CC      scripts/mod/devicetable-offsets.s
>           GEN     scripts/mod/devicetable-offsets.h
>           HOSTCC  scripts/mod/file2alias.o
>           HOSTLD  scripts/mod/modpost
>           DTC     arch/powerpc/boot/virtex440-ml510.dtb
>         Error: arch/powerpc/boot/dts/virtex440-ml510.dts:374.6-7 syntax error
>         FATAL ERROR: Unable to parse input tree
>         make[1]: *** [arch/powerpc/boot/virtex440-ml510.dtb] Error 1
>         make: *** [virtex440-ml510.dtb] Error 2
...
>            interrupt-map = <
>         # 375 "arch/powerpc/boot/dts/virtex440-ml510.dts"
>             0x3000 0 0 1 &xps_intc_0 3 2
>             0x3000 0 0 2 &xps_intc_0 2 2
>             0x3000 0 0 3 &xps_intc_0 5 2
>             0x3000 0 0 4 &xps_intc_0 4 2

I /think/ what's happening here is that dtc's rule for #line parsing
allows the formats:

# LINE FILENAME
or:
#LINE FILENAME FLAGS

where FLAGS is an integer

The lexer rule that optionally consumes flags requires some WS
(white-space) between the filename and flags. It looks like this
whitespace can actually cross a line boundary, so it ends up consuming
the first "0" of the hex constant on the next line, which then leaves
"x3000" to be parsed as cell data, which is a syntax error.

You can hack around this for testing by doing one of a few things:

a) Add an extra integer on to the end of the problematic #line directives.

b) Remove the leading "0x" from the constants following the #line
directives. I think this will still mean dtc eats the 3000 as part of
the #line directive, but hides the syntax error.

The solution here is to make dtc's #line matching regex:

<*>^"#"(line)?{WS}+[0-9]+{WS}+{STRING}({WS}+[0-9]+)? {

... use someting other than {WS} in the final instance; some kind of
{WS} that won't match/cross line boundaries. I'll see if I can cook up a
patch for this.
