Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaAGNOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:14:18 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:55236 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbaAGNOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:14:09 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 7 Jan 2014 13:14:01 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 4/4] drm/i915: check LVDS for EDID on GPU switches
Message-ID: <20140107131401.GF8991@nuc-i3427.alporthouse.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <1389088723-30959-5-git-send-email-artagnon@gmail.com>
 <20140107104553.GC8991@nuc-i3427.alporthouse.com>
 <CALkWK0mSPvjDUaGDS9jP=PSynFFTtw5U8WX40PzzixUwvgokSg@mail.gmail.com>
 <20140107114854.GE8991@nuc-i3427.alporthouse.com>
 <CALkWK0kcEOkao9HUv_0GnBawcwaNyNfe-KWCTZ348yvp7oy90g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0kcEOkao9HUv_0GnBawcwaNyNfe-KWCTZ348yvp7oy90g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 06:35:26PM +0530, Ramkumar Ramachandra wrote:
> Chris Wilson wrote:
> > Rather than special casing lvds (especially when there are other panel
> > connectors that can also be muxed), extend the connector interface to
> > support a reprobe and walk over all connectors associated with i915
> > after a switcheroo event.
> 
> Okay, so I can see the following get_edid functions:
> 
>   intel_lvds_get_edid()
>   intel_crt_get_edid()
>   intel_sdvo_get_edid()
>   intel_dp_get_edid()
> 
> In the hdmi case, drm_get_edid() is called in two places:
> intel_hdmi_detect() and intel_hdmi_detect_audio(); should I factor out
> something into a corresponding intel_hdmi_get_edid() function?
> 
> Now, in i915_switcheroo_reprobe(), I need to call all these functions,
> right? They all accept a a generic drm_connector and an specific
> i2c_adapter. But how do I do that without exporting each of these
> functions and their adapters?

If you look at struct intel_connector, you will see space for adding a
callback that each of the LVDS/CRT/SDVO/DP connectors can hook into if
they want to reprobe after a switcheroo.

  struct intel_connector *connector;
  list_for_each_entry(connector,
                    &dev->mode_config.connector_list,
		    base.head) {
	connector->reprobe(connector);
  }

(or something similar) would do in the switcheroo callback.

-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
