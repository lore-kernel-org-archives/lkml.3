Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3IRNeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:34:06 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48001 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3IRNeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:34:03 -0400
Date: Wed, 18 Sep 2013 15:34:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20130918133400.GA8141@gmail.com>
References: <1379497571-14208-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379497571-14208-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:

> On OpenEmbedded the symbol files are located under a .debug folder on
> the same folder as the binary file.
> 
> This patch adds support for such files.
> 
> Without this patch on perf top you can see:
> 
> no symbols found in /usr/lib/gstreamer-1.0/libtheoraenc.so.1.1.2, maybe install
> a debug package?
> 
> 84.56%  libtheoraenc.so.1.1.2       [.] 0x000000000000b346
> 
> With this patch symbols are shown:
> 
> 19.06%  libtheoraenc.so.1.1.2       [.] oc_int_frag_satd_thresh_mmxext
> 9.76%   libtheoraenc.so.1.1.2       [.] oc_analyze_mb_mode_luma
> 5.58%   libtheoraenc.so.1.1.2       [.] oc_qii_state_advance
> 4.84%   libtheoraenc.so.1.1.2       [.] oc_enc_tokenize_ac
> ...

Nice! Two nits are remaining:

> @@ -64,6 +65,21 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
>  			 symbol_conf.symfs, dso->long_name);
>  		break;
>  
> +	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:{

I think you missed the review feedback I gave for this line in the 
previous mail.

> +		char *last_slash;
> +
> +		last_slash = dso->long_name + dso->long_name_len;
> +		while (last_slash != dso->long_name && *last_slash != '/')
> +			last_slash--;
> +
> +		size -= snprintf(file, MIN(size, strlen(symbol_conf.symfs) +
> +				(last_slash - dso->long_name) + 2), "%s%s",
> +				symbol_conf.symfs, dso->long_name);
> +		snprintf(file + strlen(file), size, ".debug%s",
> +				last_slash);
> +		break;
> +	}

The 'MIN' still looks superfluous (btw., we use min()) - why not simply 
set 'size' to the correct value when you set and iterate last_slash?

(and scnprintf() should be used, as Arnaldo suggested.)

Thanks,

	Ingo
