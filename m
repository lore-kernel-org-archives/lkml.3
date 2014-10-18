Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaJRKdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 06:33:12 -0400
Received: from mail.efficios.com ([78.47.125.74]:54445 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJRKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 06:33:11 -0400
Date: Sat, 18 Oct 2014 10:31:52 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: linux-kernel@vger.kernel.org, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Message-ID: <808977110.11119.1413628312625.JavaMail.zimbra@efficios.com>
In-Reply-To: <1895341174.11073.1413626706382.JavaMail.zimbra@efficios.com>
Subject: LTTng-UST bytecode interpreter
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [212.144.255.202]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: LTTng-UST bytecode interpreter
Thread-Index: i06C5IHZJq+FnhyH5Lh6umgw6z+52g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexei,

Following our Plumbers discussion, here are links to
lttng-ust and lttng-tools parts that are relevant to
the bytecode I use for tracepoint filtering:

http://git.lttng.org/?p=lttng-tools.git;a=summary
src/lib/lttng-ctl/filter/*.[ch]
  -> parser of filter expressions to AST, then to
     intermediate representation, followed by
     bytecode generation.

The bytecode is then moved from the client to the
application being traced through the lttng-sessiond
daemon.

http://git.lttng.org/?p=lttng-ust.git;a=summary
liblttng-ust/lttng-filter.c:
  filter "linker" attaching bytecode to tracepoint.
  _lttng_filter_event_link_bytecode() has all the
  steps required to translate a bytecode into
  something the interpreter can use.

liblttng-ust/lttng-filter-specialize.c:
  Perform type specialization of some opcodes. This
  is done after linking to an event fields, now that
  we know their type.

liblttng-ust/lttng-filter-validator.c
  Validation of the bytecode: making sure typing is
  consistent, checks there are no loops (no backward
  jump).

liblttng-ust/lttng-filter-interpreter.c
  Bytecode interpreter, executes quickly without any
  checks, relying on the fact that they were already
  performed by the validator. It is a threaded
  interpreter which has 2 registers aliasing the top
  of its stack.

My general approach is to use an interpreter to deal
with the general case, which makes porting to new
architectures easy. We can then have JIT phases if
we want to eventually translate this bytecode into
native instruction.

Working with a bytecode which has a slightly higher
level semantic allows dealing with strings as a basic
type in addition to integers and floating point values.

Please note that the current bytecode is limited to
64-bit integers. We can eventually extend it to be
more compact (8, 16, 32-bit integers).

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
