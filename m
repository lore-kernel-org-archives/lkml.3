Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3BRTxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:53:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3BRTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:53:18 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=A1c2XFf7dFUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F-nNtcodUUAA:10 a=fAfWBmd5Mb2GVkWXFAQA:9 a=PUjeQqilurYA:10 a=hoPC4-FNjB2KoLwe:21 a=SxClT33DH1kedRVZ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361217195.23152.170.camel@gandalf.local.home>
Subject: Re: [PATCH v5 00/45] CPU hotplug: stop_machine()-free CPU hotplug
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, walken@google.com, mingo@kernel.org,
        linux-arch@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        rjw@sisk.pl, namhyung@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        oleg@redhat.com, sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 18 Feb 2013 14:53:15 -0500
In-Reply-To: <CAKfTPtC4hbXXWO=_zsGYryM9hpWaGFLbiY+jiLf=koLa4xGJOQ@mail.gmail.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
	 <510FBC01.2030405@linux.vnet.ibm.com> <87haloiwv0.fsf@rustcorp.com.au>
	 <51134596.4080106@linux.vnet.ibm.com>
	 <20130208154113.GV17833@n2100.arm.linux.org.uk>
	 <51152B81.2050501@linux.vnet.ibm.com> <51153F72.1060005@linux.vnet.ibm.com>
	 <CAKfTPtCe+cD7LLkb+D6pqG1SwG2V08ws=4XO3ttHEHV2qgmqPg@mail.gmail.com>
	 <5118E2CD.90401@linux.vnet.ibm.com>
	 <20130211190852.GA5695@linux.vnet.ibm.com>
	 <5119BDFD.1000909@linux.vnet.ibm.com>
	 <CAKfTPtAo2hQTfBKTVUuLKgsGJ2ZLD0UTR3fH9UFuJwyFt4n__w@mail.gmail.com>
	 <511E8F3C.2010406@linux.vnet.ibm.com>
	 <CAKfTPtD=2jn1AVjuhVP1ot7_8x9-W4==hNGZET5N9tRE7gtyMw@mail.gmail.com>
	 <512203B3.7090002@linux.vnet.ibm.com> <512207A6.4000402@linux.vnet.ibm.com>
	 <CAKfTPtA1aTseD6Gntkf_zbCEbfZzt3P2-P1un6iF5_1TdVLjRQ@mail.gmail.com>
	 <1361201422.23152.154.camel@gandalf.local.home>
	 <CAKfTPtC4hbXXWO=_zsGYryM9hpWaGFLbiY+jiLf=koLa4xGJOQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 17:50 +0100, Vincent Guittot wrote:

> yes for sure.
> The problem is more linked to cpuidle and function tracer.
> 
> cpu hotplug and function tracer work when cpuidle is disable.
> cpu hotplug and cpuidle works if i don't enable function tracer.
> my platform is dead as soon as I enable function tracer if cpuidle is
> enabled. It looks like some notrace are missing in my platform driver
> but we haven't completely fix the issue yet
> 

You can bisect to find out exactly what function is the problem:

 cat /debug/tracing/available_filter_functions > t
 
f(t) {
 num=`wc -l t`
 sed -ne "1,${num}p" t > t1
 let num=num+1
 sed -ne "${num},$p" t > t2

 cat t1 > /debug/tracing/set_ftrace_filter
 # note this may take a long time to finish

 echo function > /debug/tracing/current_tracer

 <failed? bisect f(t1), if not bisect f(t2)>
}




