Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3A3U12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:27:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54103 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3A3U1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:27:25 -0500
Message-ID: <51098229.7080508@wwwdotorg.org>
Date: Wed, 30 Jan 2013 13:27:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1359514939-15653-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 08:02 PM, Alexandre Courbot wrote:
> Add support for the Chunghwa CLAA101WA01A display panel.

> diff --git a/Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt b/Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt

> +Chunghwa CLAA101WA01A Display Panel
> +
> +Required properties:
> +- compatible: "chunghwa,claa101wa01a"
> +- pnl-supply: regulator controlling power supply to the panel
> +- bl-supply: regulator controlling power supply to the backlight
> +- pnl-enable-gpios: GPIO that enables the panel
> +- bl-enable-gpios: GPIO that enables the backlight

So this looks like a reasonable binding to me. The one issue is that
it's very generic, and if we go this route, we'll probably end up with
tens or hundreds of identical or extremely similar simple bindings, and
associated drivers.

We can avoid this instead by defining something like a "simple-lcd"
binding, and associated driver, that will work for perhaps 90%, 95%,
99%, even 100%(?) of panels. Just like the above, but with:

compatible="simple-panel", "chunghwa,claa101wa01a"

instead, and the driver binding to "simple-panel" rather than
"chunghwa,claa101wa01a".

The driver can assume that a specific set of supplies (and perhaps
GPIOs) is always present, and that the /sequence/ of manipulating those
is fixed. This will avoid the need for anything like the power sequences
code. If a particular panel doesn't fit those assumptions, including the
exact sequence of manipulations for each state transition (which should
be documented in the binding) then it can get a custom driver, this also
avoiding having to define custom sequences in DT.

Things that might be parameterized/optional:

* Perhaps some GPIOs aren't always present.
* If some regulators aren't SW-controllable, DT should still provide a
fixed/dummy regulator so the driver doesn't care.
* Wait times between regulator/GPIO/... manipulation could be specified
in DT.
* For panels without EDID, CDF DT bindings can provide the list of
supported modes, otherwise we assume that the display controller that
drives the panel has been told how to access the EDID, just like it
would for an "external" display.
