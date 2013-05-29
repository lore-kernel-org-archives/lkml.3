Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966673Ab3E2Tgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:36:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966058Ab3E2TgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:36:25 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8WP5vsYk2ysA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=uasUV51kM6IA:10 a=zytuvzN0TRgR-c-fhA4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369856184.15552.76.camel@gandalf.local.home>
Subject: Re: [ring_buffer_entries] BUG: unable to handle kernel NULL pointer
 dereference at   (null)
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 15:36:24 -0400
In-Reply-To: <20130529141333.GA24064@localhost>
References: <20130529141333.GA24064@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 22:13 +0800, Fengguang Wu wrote:
> Hi Rostedt,
> 
> I got the below BUG and the first bad commit could be any of:
> 
> ce9bae55972b228cf7bac34350c4d2caf8ea0d0b
> 121aaee7b0a82605d33af200c7e9ebab6fd6e444
> 737223fbca3b1c91feb947c7f571b35749b743b6
> 45ad21ca5530efdca6a19e4a5ac5e7bd6e24f996
> a695cb5816228f86576f5f5c6809fdf8ed382ece
> 6de58e6269cd0568ca5fbae14423914eff0f7811
> ad909e21bbe69f1d39055d346540abd827190eca
> 0b85ffc293044393623059eda9904a7d5b644e36
> f5eb5588262cab7232ed1d77cf612b327db50767
> f1affcaaa861f27752a769f889bf1486ebd301fe
> f4e781c0a89d5810729772290441ac7d61f321ec
> 12883efb670c28dff57dcd7f4f995a1ffe153b2d
> 55034cd6e648155393b0d665eef76b38d49ad6bf
> 153e8ed913b022d2003866a848af9fadc041403f
> 
> We cannot bisect more due to broken builds.

No need to bisect. The bug is pretty obvious:

$ grep trace_test_buffer kernel/trace/trace_selftest.c
static int trace_test_buffer_cpu(struct trace_buffer *buf, int cpu)
static int trace_test_buffer(struct trace_buffer *buf, unsigned long
*count)
         * The trace_test_buffer_cpu runs a while loop to consume all
data.
                ret = trace_test_buffer_cpu(buf, cpu);
        ret = trace_test_buffer(&tr->trace_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, NULL);
                ret = trace_test_buffer(&tr->max_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, NULL);
                ret = trace_test_buffer(&tr->max_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, NULL);
        ret = trace_test_buffer(&tr->max_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, NULL);
        ret = trace_test_buffer(&tr->max_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, NULL);
                ret = trace_test_buffer(&tr->max_buffer, &count);
        ret = trace_test_buffer(&tr->trace_buffer, &count);
        ret = trace_test_buffer(tr, &count);


Notice that all but the last one passes in &tr->trace_buffer or
&tr->max_buffer. That last one happens to be in:
trace_selftest_startup_branch()

Thanks!

-- Steve


