Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3HVR7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:59:39 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:41667 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753515Ab3HVR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:59:38 -0400
Date: Thu, 22 Aug 2013 14:00:51 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Robert Richter <rric@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 08/12] perf, persistent: Exposing persistent events
 using sysfs
In-Reply-To: <1377180807-12758-9-git-send-email-rric@kernel.org>
Message-ID: <alpine.DEB.2.02.1308221344500.26486@pianoman.cluster.toy>
References: <1377180807-12758-1-git-send-email-rric@kernel.org> <1377180807-12758-9-git-send-email-rric@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.52165189.013B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Robert Richter wrote:

> From: Robert Richter <robert.richter@linaro.org>
> 
> Expose persistent events in the system to userland using sysfs. Perf
> tools are able to read existing pmu events from sysfs. Now we use a
> persistent pmu as an event container containing all registered
> persistent events of the system. This patch adds dynamically
> registration of persistent events to sysfs. E.g. something like this:
> 
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:23

...

> @@ -15,6 +16,26 @@ Contact:	Jiri Olsa <jolsa@redhat.com>
>  			attr2 = 'config:0-7'
>  			attr3 = 'config:12-35'
>  
> -		Example: 'config1:1,6-10,44'
> -		Defines contents of attribute that occupies bits 1,6-10,44 of
> -		perf_event_attr::config1.
> +		Syntax			Description
> +
> +		config[012]*:<bits>	Each attribute of this group
> +					defines the 'hardware' bitmask
> +					we want to export, so that
> +					userspace can deal with sane
> +					name/value pairs.
> +
> +		attr<index>:<bits>	Set any field of the event
> +					attribute. The index is a
> +					decimal number that specifies
> +					the u64 value to be set within
> +					struct perf_event_attr.

Ugh this is ugly.  You might also want to specify that the "index"
value starts at 0 which threw me for a bit when I was trying to figure
out what was going on.  You might also want to clarify the previous
part of the document which uses "attr" to mean something else.

Is this endian clean?  Will attr5:23 point to the same bit on a big-endian 
machine as on little-endian?

If we're going to have to have an ugly interface like this we might
as well do something more human readable, since anything that parses this 
is going to have to rebuild the struct perf_event_attr by hand anyway
(unless you propose people blindly set bits at offsets using pointer math
which just sounds like a bad idea).

For example, just give up and let someone specify the actual field name
like "persistent" and have the tools handle that. 

/sys/bus/event_source/devices/persistent/events/mce_record
   persistent,config=106

/sys/bus/event_source/devices/persistent/format/persistent
    attr_persistent

That way you could also add things like
/sys/bus/event_source/devices/persistent/format/precise_ip
    attr_precise_ip:0-1
  
Although I still think exposing the full huge attr stuct via sysfs is just 
silly.  Isn't there some better way?  I'm not aware of any other syscall
that exports things like this.

Vince
