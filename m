Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650Ab3IEMpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:45:52 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50845 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759668Ab3IEMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:45:51 -0400
Date: Thu, 5 Sep 2013 13:45:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>, michael.hudson@linaro.org
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
Message-ID: <20130905124508.GE9696@mudshark.cambridge.arm.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
 <1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

[adding Michael, since I know he was interested in this]

On Wed, Sep 04, 2013 at 07:04:14PM +0100, Jean Pihet wrote:
> On ARM the debug info is not present in the .eh_frame sections but
> instead in .debug_frame.
> Use libunwind to load and parse the debug info.

How have you tested this? Regardless of whether or not I apply this patch, I
get the same (broken/truncated) callchains for userspace in perf report.

E.g. the following stupid program (built with -O0 -g):

--->8

void bar(void)
{
        int i;
        for (i = 0; i < 1000000; ++i)
                asm volatile("nop" ::: "memory");
}

void foo(void)
{
        bar();
}


int main(void)
{
        foo();
        return 0;
}

8<---

Gives me an incomplete callchain:

# Overhead   Command      Shared Object                           Symbol
# ........  ........  .................  ...............................
#
     0.00%  unwindme  unwindme           [.] bar                        
            |
            --- bar

This is the same with or without your patch.

Will
