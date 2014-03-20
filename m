Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbaCTMmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:42:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63027 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbaCTMmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:42:42 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-57-532ae23f7a5c
Message-id: <532AE239.9000800@samsung.com>
Date: Thu, 20 Mar 2014 13:42:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: mark.rutland@arm.com, mturquette@linaro.org, gregkh@linuxfoundation.org,
        t.figa@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        robh+dt@kernel.org, galak@codeaurora.org, grant.likely@linaro.org,
        linux@arm.linux.org.uk, m.szyprowski@samsung.com, t-kristo@ti.com
Subject: Re: [RFC PATCH v2 0/2] clk: Support for DT assigned clock parents and
 rates
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
 <53187C13.3040202@st.com>
In-reply-to: <53187C13.3040202@st.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4ZV37R1rBBs/faljMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu8Wmx9dYLS7vmsNmcfsyr8XaI3fZLZZev8hk8ej0YjaLpxMuslm0
	7j3CbjFj8ks2iyVPO9gs1s94zeIg4LFm3hpGj5bmHjaPy329TB6bVnWyedy5tofNY//cNewe
	m5fUe/RtWcXo8fTHXmaP4ze2M3l83iQXwB3FZZOSmpNZllqkb5fAlbHvsn3BWf6KH1PPsjcw
	nuLpYuTkkBAwkTi0bh0jhC0mceHeerYuRi4OIYGljBLreyYwQjifGCX+9ZxjA6niFdCSWH/q
	HZjNIqAqsWfKK2YQm03AUKL3aB/YJFGBCIm5EzdD1QtK/Jh8jwXEFhEokNi1cyk7yFBmgX1M
	Eu03boA1CwuESexdfQzMFhJIklje8wxsEKeAmsT59n9gNrOAjsT+1mlsELa8xOY1b5knMArM
	QrJjFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIibyvOxiXHrM6xCjAwajE
	w7tij2awEGtiWXFl7iFGCQ5mJRHeqTe0goV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwmkvekzFh
	0vo9paAhKumnxYK1NWYzS/buXqonwfk2/vhK34UOa+e4+v/vPPDs5P2bwhUCXIHCzxmqy40q
	7XeFLGBsztExL4r+OeW50VqFww6312vdtevWlor+OkFx3YLqzlnLE87t0TA0ynO68O1Uhu0i
	dx472Rl1e7xFJykcDnC9vpBL56itEktxRqKhFnNRcSIAzOZEvZoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On 06/03/14 14:45, Maxime Coquelin wrote:
> Hi Sylwester,
> 
> 	I like the principle of your implementation, but I have two questions:
> 	1 - How can we manage PM with this solution, as the parent/rate will be 
> set only once at probe time?
> 	2 - How to set the parent of a parent clock (which can be shared with 
> other devices)? Same question about the parent rates.

Thanks for your feedback and apologies for late reply.

IIUC your first concern is about a situation when clocks need to be
reconfigured upon each resume from system sleep or runtime PM resume ?
As I mentioned in v1 of the RFC I was considering having individual
drivers calling explicitly the clocks set up routine. Presumably this
would allow to resolve the power management related issue.
One example I'm aware the approach as in this RFC wouldn't work is
when a device in a SoC belongs to a power domain, which needs to be
first switched on before we can start setting up and the clocks'
configuration get lost after the power domain switch off.

OTOH I suspect devices for which one-time clocks setup is sufficient
will be quite common. And for these there would need to be a single
call to the setup routine in probe() I guess, since it wouldn't be
possible to figure out just from the DT data when the actual call
should be made.

For a global clocks configuration, I thought about specifying that
in the clocks controller node, and then to have the setup routine
called e.g. from of_clk_init(). I think that could work well enough,
together with the patch [1], adding clock dependencies handling.
But then the clock frequency set up function would need to be
modified to respect the clock parent relationships, similarly as
in patch series [2]. A just noticed [2] recently, after posting
this RFC (adding Tero at Cc).

--
Regards,
Sylwester

[1] http://www.spinics.net/lists/arm-kernel/msg310507.html
[2] http://www.spinics.net/lists/linux-omap/msg103069.html
