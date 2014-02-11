Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaBKV5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:57:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58921 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBKV5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:57:37 -0500
Date: Tue, 11 Feb 2014 15:55:19 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
Message-ID: <20140211215519.GJ841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1596542.hkJp71u3OJ@avalon>
 <20140211164825.GC841@joshc.qualcomm.com>
 <6446980.WMjvBYStRY@avalon>
 <20140211180845.GG841@joshc.qualcomm.com>
 <CAMuHMdVkPLe5986hYPApoQr7oJSb6U2P71=nP+9mtvtaskdHXg@mail.gmail.com>
 <CAL_JsqKnsr-9nSjCGvroC0nDK36vQUnwMWj=cPjvUbRymmHFOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKnsr-9nSjCGvroC0nDK36vQUnwMWj=cPjvUbRymmHFOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:30:33PM -0600, Rob Herring wrote:
> On Tue, Feb 11, 2014 at 12:29 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Tue, Feb 11, 2014 at 7:08 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> >> It sure would be convenient if platform_device had a 'const struct
> >> of_device_id *of_id_entry' member similar to the existing struct
> >> platform_device_id one, that was set up during platform device matching.
> >> Most platform_driver users of of_match_node() would simply go away.
> >
> > Can't the entry be shared for both platform_device_id and of_device_id?
> > Only one of them can be valid at the same time, right?
> >
[..]
> 
> I believe this is the reason drivers have to call of_match_device:
> 
> commit b1608d69cb804e414d0887140ba08a9398e4e638
> Author: Grant Likely <grant.likely@secretlab.ca>
> Date:   Wed May 18 11:19:24 2011 -0600
>
>     drivercore: revert addition of of_match to struct device
>
>     Commit b826291c, "drivercore/dt: add a match table pointer to struct
>     device" added an of_match pointer to struct device to cache the
>     of_match_table entry discovered at driver match time.  This was unsafe
>     because matching is not an atomic operation with probing a driver.  If
>     two or more drivers are attempted to be matched to a driver at the
>     same time, then the cached matching entry pointer could get
>     overwritten.
>
>     This patch reverts the of_match cache pointer and reworks all users to
>     call of_match_device() directly instead.
>
>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Interesting, thanks for the history!  I'm wondering if this same problem
exists for the existing platform_device_id cached pointer as well.

Okay, so maybe caching a pointer in the device isn't the best option,
what if we considered extending the platform_driver callbacks to include
a set of per-method (?) probe callbacks which do provide a handle to
matched identifiers.

In the case of a totally contrived platform_driver supporting ACPI, OF,
and !OF configurations, it might look something like:

	static const struct of_device_id acme_of_table[] = {
		/* ... */
		{ },
	};
	MODULE_DEVICE_TABLE(of, acme_of_table);

	static int acme_probe_of(struct platform_device *pdev,
				 const struct of_device_id *id)
	{
		/* ... */
		return 0;
	}

	static const struct acpi_device_id acme_acpi_table[] = {
		/* ... */
		{ },
	};
	MODULE_DEVICE_TABLE(acpi, acme_acpi_table);

	static int acme_probe_acpi(struct platform_device *pdev,
				   const struct acpi_device_id *id)
	{
		/* ... */
		return 0;
	}

	static const struct platform_device_id acme_platform_table[] = {
		/* ... */
		{ },
	};
	MODULE_DEVICE_TABLE(platform, acme_platform_table);

	static int acme_probe_acpi(struct platform_device *pdev,
				   const struct platform_device_id *id)
	{
		/* ... */
		return 0;
	}

	static int acme_probe_name(struct platform_device *pdev)
	{
		/* ... */
		return 0;
	}

	static struct platform_driver acme_driver = {
		.probe_of	= acme_probe_of,
		.probe_acpi	= acme_probe_acpi,
		.probe_platform	= acme_probe_platform,
		.probe_name	= acme_probe_name,
		.remove		= acme_remove,
		.driver		= {
			.name			= "acme",
			.of_match_table		= of_match_ptr(acme_of_table),
			.acpi_match_table	= ACPI_PTR(acme_acpi_table),
		},
	};
	module_platform_driver(acme_driver);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
