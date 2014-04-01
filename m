Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaDAOXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:23:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64980 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaDAOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:23:22 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-98-533acbd72b03
Message-id: <533ACBD0.8030209@samsung.com>
Date: Tue, 01 Apr 2014 16:23:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <20140331200620.GA13881@kroah.com> <533ABCEC.8040701@codethink.co.uk>
In-reply-to: <533ABCEC.8040701@codethink.co.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xy7rXT1sFGzx6rGzx4FYrk8X8I+dY
	LfrfLGS1OPBnB6NF8+L1bBZnm96wW3ROXMJusenxNVaLy7vmsFncvsxrsfbIXXaLpdcvMlk8
	nXCRzaJ17xF2i7/bN7FYzJj8ks1i/YzXLA6CHmvmrWH0aGnuYfO43NfL5PHs5WQmj9kdM1k9
	Nq3qZPO4c20Pm8f+uWvYPTYvqffo/2vg0bdlFaPH501yATxRXDYpqTmZZalF+nYJXBnPduxi
	LNjGX3Gi7ytLA+NMni5GTg4JAROJKbtms0PYYhIX7q1n62Lk4hASWMooce/EMVYI5xOjxN7D
	v4GqODh4BbQknt0Aa2ARUJXY0/4azGYTMJToPdrHCGKLCkRIzJ24mQ3E5hUQlPgx+R4LSKuI
	gL/E0s9FICOZBSYwS7T1zQPrFRaIljjTsJEZYtdpRoktx+8wgSQ4BfQlrhz7wwpiMwvoSOxv
	ncYGYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	WPy6g3HpMatDjAIcjEo8vBbllsFCrIllxZW5hxglOJiVRHitV1gFC/GmJFZWpRblxxeV5qQW
	H2Jk4uCUamBcVbPheWuBn+Xbg36rD3sVvjeelRVs+EPkd+DZH9Gl/7cd6zC9veGFe4LBR165
	2v6q1hJjO51Ta80s3p3onTH/1cI3flUz1kz/cvlRglbig7vnd3988zcqZHF0V0m5o/6au1wW
	Xx8u0n/183ha5XuRKVn3zGetY5fc6M/739ZxqXMXz79XAbbOSizFGYmGWsxFxYkAtZuBRKMC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 15:19, Ben Dooks wrote:
> On 31/03/14 21:06, Greg KH wrote:
>> > On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
[...]
>> > I don't understand why you need the driver core to initialize this one
>> > type of thing?  That should be in a driver, or in a class, or at worse
>> > case, the platform code.
>> >
>> > What makes clocks so "unique" here?

The reason I put it in the driver core was mainly to avoid having many
drivers doing same call to this initialization function.
I was considering moving it to the bus code, still there are several
buses for which it would need to be repeated.

Maybe really_probe() is not a best place to put this, nonetheless
the requirements I could list were:

 1. not involving individual drivers,
 2. have such an initialization call done for all devices, irrespective
    of Linux bus or class type,
 3. Handle errors properly, e.g. defer driver probing if a clock for
   a device is not yet available.

One advantage I could see from making the call from within a device
driver is that a device could keep using the common DT bindings and
replace the common initialization function with a private one, if
there is a need for some quirks handled for a device. With approach
as in this patch it's difficult to override the default behaviour.
However then there is a question whether we strive for the clocks
management to be possibly kept away from device drivers.

> I suppose the issue here is that a lot of drivers currently use
> clocks and a number of systems have badly setup default clock trees
> at start time.
> 
> Mark Brown and others have argued that the management of clocks which
> is common to all devices should not live in the driver.

True, motivation behind this patch series was also replacing custom
code in multiple drivers doing similar clock rate or parent setting
by a common code, using standardized DT binding.

--
Thanks,
Sylwester
