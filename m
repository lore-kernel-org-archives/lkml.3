Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbbAVP2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:28:20 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:46249 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAVP2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:28:18 -0500
Date: Thu, 22 Jan 2015 15:27:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/3] perf symbols: Ignore mapping symbols on aarch64
Message-ID: <20150122152715.GZ26493@n2100.arm.linux.org.uk>
References: <1421902378-3634-1-git-send-email-victor.kamensky@linaro.org>
 <1421902378-3634-2-git-send-email-victor.kamensky@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421902378-3634-2-git-send-email-victor.kamensky@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 08:52:56PM -0800, Victor Kamensky wrote:
> Aarch64 ELF files use mapping symbols with special names $x, $d
> to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
> IHI 0056B", section "4.5.4 Mapping symbols").
> 
> The patch filters out these symbols at load time, similar to
> "696b97a perf symbols: Ignore mapping symbols on ARM" changes
> done for ARM before V8.

I thought I'd commented that this should probably use the same test that
we already have established elsewhere in the kernel, namely in the
kallsyms and module code:

/*
 * This ignores the intensely annoying "mapping symbols" found
 * in ARM ELF files: $a, $t and $d.
 */
static inline int is_arm_mapping_symbol(const char *str)
{ 
        return str[0] == '$' && strchr("axtd", str[1])
               && (str[2] == '\0' || str[2] == '.');
}

We really shouldn't be writing the same check for the same symbols in
different ways.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
