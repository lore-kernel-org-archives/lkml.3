Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ARDgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3ARDgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:36:05 -0500
Date: Thu, 17 Jan 2013 22:35:57 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jovi.zhangwei@huawei.com
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
Message-ID: <20130118033557.GE13185@redhat.com>
References: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com> <y0mliceujz4.fsf@fche.csb> <CACV3sbKk3euv8N4SbBegJ=iYuUxfdynZ_1GNtfkwGzwGDcqATw@mail.gmail.com> <20130104151950.GB21860@redhat.com> <CACV3sbKYPUSOsccptgyJtaEp4Oxx6yX0XgVEEa+BfTPLpD28qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACV3sbKYPUSOsccptgyJtaEp4Oxx6yX0XgVEEa+BfTPLpD28qA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jan 18, 2013 at 09:24:55AM +0800, Jovi Zhang wrote:
> Let us continue this ktap topic in this thread :).
> ktap code is public available at github, please clone from:
> https://github.com/ktap/ktap.git
> [...]

Neat stuff.  I have one set of initial observations: even with a nice
small bytecode language, the VM has to be skeptical and careful.  For
example, some dangers:

- any dynamic memory allocation from within the context of an
  arbitrary tracepoints (table_* functions, stack frames)
- unchecked arithmetic (division-by-zero - OP_DIV, overflows,
  function arity limits)
- time-quantity of computation (limit loop iterations / #-bytecodes?,
  DO_JMP infinite loops)
- stack-frame usage of interpreter (if internally recursive, or if 
  too much state kept on stack)
- trusting validity of bytecode (imagine an attacker sending random
  or harmful junk, jumping out of bytecode ranges)
- calls out from interpreter into native code - to ensure that *all*
  those functions (transitively) are valid to call from general
  e.g. tracepoint context (e.g. sleeps often aren't)
- (and these problems get even worse with evaluation from the
  context of kprobes)


- FChE
