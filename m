Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaLSBmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:42:04 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50687 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLSBmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:42:02 -0500
Message-ID: <54938266.9090007@gmail.com>
Date: Thu, 18 Dec 2014 18:41:58 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com> <17321.1418939104@turing-police.cc.vt.edu> <549351A7.9040408@gmail.com>
In-Reply-To: <549351A7.9040408@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/14 3:13 PM, David Ahern wrote:
> Are you seeing something different?

I put a tracepoint in the ipv4/ipv6 add/del address code. The IPv4 one 
prints the address using pi4 and pI4 and the IPv6 using pi6, pI6 and pI6c.

Using ifconfig eth1 1.2.3.4/24

I get this for trace_pipe which uses the in-kernel printf code:

root@localhost:/sys/kernel/debug/tracing/events# cat ../trace_pipe
         ifconfig-601   [000] ....   710.660611: ipv4_del_addr: 
pI4=1.2.3.4 pi4=001.002.003.004
         ifconfig-602   [000] ....   720.833559: ipv4_add_addr: 
pI4=1.2.3.4 pi4=001.002.003.004
         ifconfig-602   [000] .Ns.   720.833966: ipv6_add_addr: 
pi6=fe80000000000000000202fffe020211 
pI6=fe80:0000:0000:0000:0002:02ff:fe02:0211 pI6c=fe80::2:2ff:fe02:211
         ifconfig-602   [000] ....   720.835413: ipv4_del_addr: 
pI4=1.2.3.4 pi4=001.002.003.004
         ifconfig-602   [000] .N..   720.835451: ipv4_add_addr: 
pI4=1.2.3.4 pi4=001.002.003.004


And this using perf:
root@localhost:~# perf record -a -e  ipv4:* -e ipv6:* --no-buffering | 
perf --no-pager script

        ifconfig   601 [000]   710.912862: ipv4:ipv4_del_addr: 
pI4=1.2.3.4 pi4=001.002.003.004
         ifconfig   602 [000]   721.090776: ipv4:ipv4_add_addr: 
pI4=1.2.3.4 pi4=001.002.003.004
         ifconfig   602 [000]   721.091177: ipv6:ipv6_add_addr: 
pi6=fe80000000000000000202fffe020211 
pI6=fe80:0000:0000:0000:0002:02ff:fe02:0211 pI6c=fe80::2:2ff:fe02:211
         ifconfig   602 [000]   721.092626: ipv4:ipv4_del_addr: 
pI4=1.2.3.4 pi4=001.002.003.004
         ifconfig   602 [000]   721.092648: ipv4:ipv4_add_addr: 
pI4=1.2.3.4 pi4=001.002.003.004

(Don't be fooled by the differing timestamps; data collected from both 
using the same exact command. timestamp differences are perf vs tracing.)

which suggest with the patch perf output matches tracing.

David

