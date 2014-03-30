Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaC3JUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 05:20:09 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:56159 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaC3JUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 05:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140330035009.GB22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-11-git-send-email-jovi.zhangwei@gmail.com>
	<20140330035009.GB22728@two.firstfloor.org>
Date: Sun, 30 Mar 2014 17:12:51 +0800
Message-ID: <CAGdX0WHK-EhGYHELxr-H_A+w1ZDWWhDpxsvB+=grMgFNpFsZ4g@mail.gmail.com>
Subject: Re: [PATCH v2 10/29] ktap: add string handling code(kernel/trace/ktap/kp_[str|mempool].[c|h])
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 11:50 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> It's not clear to me why a kernel script language needs
> all that complicated string interning code.
>
> What kind of scripts would create as many strings that
> it would be worth it?
>
> I think it would be better to replace it with a really
> simple non interning dynamic string type.
>
Basically I think string interning is very useful in ktap, and
the implementation is not complicated(kp_str_new function
is very simple).

String interning will make string comparison and table index
extremely fast, just pointer equality, no strcmp. table index
is heavily used in these dynamic tracing tool ktap/stap/dtrace.

String interning make there don't need to copy whole string
each time when use string key in associative array(table)
(stap/dtrace need copy it), and don't need to compute
string hash every time when use string table key.
(Things became more easily if need to support multi-key
table, ktap don't need to pre-allocate string in table)

See test/benchmark/cmp_table.sh, that script compare
table operation between ktap with stap, the result is very
inspiring, ktap table operation overhead is quite lower than
stap, especially when use constant string key.

But I agree with you partly, because in some cases we don't
want/need to interning all string, for example:
    trace xxx:yyy {
        var str = cast("char *", arg1)
        print(str)
    }

In above case, arg1 is a long kernel string, and no table insert,
so definitely no need to interned, so we need to add
KTAP_TRAWSTR to represent these values.

The simplicity design of ktap make it very flexible to support
different kind of value type. :)

Thanks.

Jovi
