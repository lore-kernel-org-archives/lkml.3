Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaESJ73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaESJ72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:59:28 -0400
Date: Mon, 19 May 2014 11:58:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, namhyung.kim@kernel.org,
        Michael Lentine <mlentine@google.com>
Subject: Re: [PATCH 2/2] perf tools: add automatic remapping of Android
 libraries
Message-ID: <20140519095854.GB5027@krava.brq.redhat.com>
References: <1400282087-4616-1-git-send-email-eranian@google.com>
 <1400282087-4616-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400282087-4616-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 01:14:47AM +0200, Stephane Eranian wrote:
> From: Michael Lentine <mlentine@google.com>
> 
> This patch automtically adjusts the path of MMAP records
> associated with Android system libraries. It enables running
> perf reporting tools directly on the Android system natively.

could the changelog have more info about the lib name changes?

SNIP

> +
> +	if (!strncmp(filename, "/data/app-lib", 13)) {
> +		char *apk_path;
> +
> +		if (!app_abi_length)
> +			return false;
> +
> +		new_length = 7 + app_abi_length + lib_length;
> +
> +		apk_path = getenv("APK_PATH");
> +		if(apk_path) {
> +			snprintf(*newfilename, new_length + strlen(apk_path) + 1,
> +				 "%s/libs/%s/%s", apk_path, app_abi, libname);
> +		} else {
> +			snprintf(*newfilename, new_length,
> +				 "libs/%s/%s", app_abi, libname);
> +		}

missing check for overflowing PATH_MAX for 'new_length' and 'new_length + strlen(apk_path) + 1'

> +		return true;
> +	}
> +
> +	if (!strncmp(filename, "/system/lib/", 11)) {
> +		char *ndk, *app;
> +		const char *arch;
> +		size_t ndk_length;
> +		size_t app_length;
> +
> +		ndk = getenv("NDK_ROOT");
> +		app = getenv("APP_PLATFORM");
> +
> +		if (!(ndk && app))
> +			return false;
> +
> +		ndk_length = strlen(ndk);
> +		app_length = strlen(app);
> +
> +		if (!(ndk_length && app_length && app_abi_length))
> +			return false;
> +
> +		arch = !strncmp(app_abi, "arm", 3) ? "arm" :
> +		       !strncmp(app_abi, "mips", 4) ? "mips" :
> +		       !strncmp(app_abi, "x86", 3) ? "x86" : NULL;
> +
> +		if (!arch)
> +			return false;
> +
> +		new_length = 27 + ndk_length +
> +			     app_length + lib_length
> +			   + strlen(arch);

missing check for overflowing PATH_MAX for 'new_length'

> +
> +		snprintf(*newfilename, new_length,
> +			"%s/platforms/%s/arch-%s/usr/lib/%s",
> +			ndk, app, arch, libname);
> +
> +		return true;
> +	}
> +	return false;
> +}
> +

SNIP

> +		if (android) {
> +			char *newfilename_ptr = newfilename;
> +			if (replace_android_lib(filename, &newfilename_ptr))
> +				filename = newfilename;

Why is the newfilename_ptr needed? We could pass newfilename directly
to replace_android_lib function

		if (replace_android_lib(filename, newfilename))
			filename = newfilename;

thanks,
jirka
