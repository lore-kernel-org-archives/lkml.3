Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3CRXlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:41:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3CRXlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:41:52 -0400
Message-ID: <5147A63D.3040502@wwwdotorg.org>
Date: Mon, 18 Mar 2013 17:41:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: core: Split out in place value parsing
References: <1362359680-23747-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1362359680-23747-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2013 06:14 PM, Mark Brown wrote:
> Currently the value parsing operations both return the parsed value and
> modify the passed buffer. This precludes their use in places like the cache
> code so split out the in place modification into a new parse_inplace()
> operation.

Mark,

This change seems to break audio on my Tegra system with a WM8903 CODEC.
In next-20130318, reverting this plus "regmap: cache: Store caches in
native register format where possible" which depends on it does solve
the problem.

Looking at the raw WM8903 registers using i2cdump shows that for example
without these patches, register 39h is set to 0x0020, but with them it's
set to 0x0021, so the headphones are muted. In both cases, the regmap
debugfs file thinks the value last written is 0xa1 (the 0x80 bit isn't
actually state stored in HW, so the only relevant difference is in the
LSB). There are numerous other differences in i2cdump output.

It took a very quick look at the patch and couldn't see anything
actively wrong. I wonder if one of the existing unconverted users of
.parse_val() relies on the in-place modification of the buffer as well
as getting the result back, and so should have been converted to calling
both .parse_inplace() and then .parse_val()?
