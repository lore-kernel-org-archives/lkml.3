Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3G3Eh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:37:28 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65378 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3G3Eh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:37:27 -0400
X-AuditID: 9c930197-b7bfbae000000e88-1f-51f7430532f6
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 7/9] perf tools: add support for reading from /proc/kcore
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
	<1374760890-30558-8-git-send-email-adrian.hunter@intel.com>
Date: Tue, 30 Jul 2013 13:37:24 +0900
In-Reply-To: <1374760890-30558-8-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 25 Jul 2013 17:01:28 +0300")
Message-ID: <87zjt41x4r.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 25 Jul 2013 17:01:28 +0300, Adrian Hunter wrote:
> In the absence of vmlinux, perf tools uses kallsyms
> for symbols.  If the user has access, now also map to
> /proc/kcore.
>
> The dso data_type is now set to either
> DSO_BINARY_TYPE__KCORE or DSO_BINARY_TYPE__GUEST_KCORE
> as approprite.

[SNIP]
> +
> +static bool is_host_buildid_str(const char *str)
> +{
> +	u8 host_build_id[BUILD_ID_SIZE];
> +	char host_build_id_str[BUILD_ID_SIZE * 2 + 1];
> +
> +	if (sysfs__read_build_id("/sys/kernel/notes", host_build_id,
> +				 sizeof(host_build_id)))
> +		return false;
> +
> +	build_id__sprintf(host_build_id, sizeof(host_build_id),
> +			  host_build_id_str);
> +
> +	return !strcmp(str, host_build_id_str);
> +}
> +
> +/*
> + * If kallsyms is referenced by name then we look for kcore in the same
> + * directory.  Otherwise we use /proc/kcore but only if the buildid matches the
> + * host.
> + */
> +static bool kcore_filename_from_kallsyms_filename(char *kcore_filename,
> +						  const char *kallsyms_filename)
> +{
> +	char *name;
> +
> +	strcpy(kcore_filename, kallsyms_filename);
> +	name = strrchr(kcore_filename, '/');
> +	if (!name)
> +		return false;
> +
> +	if (!strcmp(name, "/kallsyms")) {
> +		strcpy(name, "/kcore");
> +		return true;
> +	}
> +
> +	if (is_host_buildid_str(name)) {

IIUC the name should start with '/' but build-id is not.  So doesn't it
always fail?

Thanks,
Namhyung


> +		strcpy(kcore_filename, "/proc/kcore");
> +		return true;
> +	}
> +
> +	return false;
> +}
