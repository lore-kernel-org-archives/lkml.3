Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbaJ3MBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:01:05 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52742 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaJ3MBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:01:03 -0400
X-Greylist: delayed 2085 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 08:01:02 EDT
Message-ID: <54522874.6040901@linaro.org>
Date: Thu, 30 Oct 2014 12:00:52 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] serial: msm: Add magic SysRq support in dmmode
References: <1414600712-20721-1-git-send-email-daniel.thompson@linaro.org> <54512B7B.905@codeaurora.org>
In-Reply-To: <54512B7B.905@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/14 18:01, Stephen Boyd wrote:
> On 10/29/2014 09:38 AM, Daniel Thompson wrote:
>> Currently the _dm RX handler detects breaks but does not pass any
>> characters to uart_handle_sysrq_char().
>>
>> The _dm optimizations combined with the port's spin lock make if
>> difficult to pass all characters to the sysrq logic because we cannot
>> safely call uart_handle_sysrq_char() when the lock is held without
>> deadlock (the console handler also takes the lock).
>>
>> Rather than passing all characters via uart_handle_sysrq_char() this patch
>> only passes the last few characters in the FIFO. This should include all
>> characters typed as a slow (human) rate. This makes the problem much
>> simpler and allows us to move the handling of these characters outside
>> of the port lock. This makes magic SysRq work if there is a human at
>> the keyboard (or a short delay in a script).
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> ---
> 
> I have a patch that I was going to send for this (Frank R. and I have
> been looking at it since a month or two ago). This patch doesn't look
> correct given that the SR register is not actually accurate and doesn't
> indicate that a break is there in the fifo. I'll Cc you on the patch,
> please test it.

Testing on IFC6410 is mostly OK.

Most sysrq actions work fine but resume from kdb is extremely
unreliable; in most cases is kills the serial RX ('echo g >
/proc/sysrq-trigger' shows that characters are still going into the FIFO
but never get to the interrupt handler).

However, this is not a regression versus my patch, resume was not
reliable with my patch either.
