Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbbAMPYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:24:37 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49550 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbbAMPYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:24:35 -0500
Message-ID: <54B538B2.8030204@osg.samsung.com>
Date: Tue, 13 Jan 2015 08:24:34 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org
Subject: Re: [PATCH V2 11/12] selftests, powerpc: Add test for all DSCR sysfs
 interfaces
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com> <1421144560-15901-12-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1421144560-15901-12-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:22 AM, Anshuman Khandual wrote:
> This test continuously updates the system wide DSCR default value
> in the sysfs interface and makes sure that the same is reflected
> across all the sysfs interfaces for each individual CPUs present
> on the system.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  tools/testing/selftests/powerpc/dscr/Makefile      |  3 +-
>  .../selftests/powerpc/dscr/dscr_sysfs_test.c       | 89 ++++++++++++++++++++++
>  2 files changed, 91 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
> 
> diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
> index 4e84309..fada526 100644
> --- a/tools/testing/selftests/powerpc/dscr/Makefile
> +++ b/tools/testing/selftests/powerpc/dscr/Makefile
> @@ -1,5 +1,6 @@
>  PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
> -	 dscr_inherit_test dscr_inherit_exec_test
> +	 dscr_inherit_test dscr_inherit_exec_test		\
> +	 dscr_sysfs_test
>  
>  CFLAGS := $(CFLAGS) -lpthread
>  
> diff --git a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
> new file mode 100644
> index 0000000..3d11439
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
> @@ -0,0 +1,89 @@
> +/*
> + * POWER Data Stream Control Register (DSCR) sysfs interface test
> + *
> + * This test updates to system wide DSCR default through the sysfs interface
> + * and then verifies that all the CPU specific DSCR defaults are updated as
> + * well verified from their sysfs interfaces.
> + *
> + * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +#include "dscr.h"
> +
> +static int check_cpu_dscr_default(char *file, unsigned long val)
> +{
> +	char buf[10];
> +	int fd, rc;
> +
> +	fd = open(file, O_RDWR);
> +	if (fd == -1) {
> +		perror("open() failed\n");
> +		return 1;
> +	}
> +
> +	rc = read(fd, buf, sizeof(buf));
> +	if (rc == -1) {
> +		perror("read() failed\n");
> +		return 1;
> +	}
> +	close(fd);
> +
> +	buf[rc] = '\0';
> +	if (strtol(buf, NULL, 16) != val) {
> +		printf("DSCR match failed: %ld (system) %ld (cpu)\n",
> +					val, strtol(buf, NULL, 16));
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static int check_all_cpu_dscr_defaults(unsigned long val)
> +{
> +	DIR *sysfs;
> +	struct dirent *dp;
> +	char file[LEN_MAX];
> +
> +	sysfs = opendir(CPU_PATH);
> +	if (!sysfs) {
> +		perror("opendir() failed\n");
> +		return 1;
> +	}
> +
> +	while ((dp = readdir(sysfs))) {
> +		if (!(dp->d_type & DT_DIR))
> +			continue;
> +		if (!strcmp(dp->d_name, "cpuidle"))
> +			continue;
> +		if (!strstr(dp->d_name, "cpu"))
> +			continue;
> +
> +		sprintf(file, "%s%s/dscr", CPU_PATH, dp->d_name);
> +		if (check_cpu_dscr_default(file, val))
> +			return 1;
> +	}
> +	closedir(sysfs);
> +	return 0;
> +}
> +
> +int test_body(void)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < COUNT; i++) {
> +		for (j = 0; j < DSCR_MAX; j++) {
> +			set_default_dscr(j);
> +			if (check_all_cpu_dscr_defaults(j))
> +				return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	return test_harness(test_body, "dscr_sysfs_test");
> +}
> 
Could you please add a .gitignore for powerpc targets as we
discussed earlier. It can be separate patch.

Also, I would like to see the test results reports using
kselftest.h - it can be separate patch in the interest of
getting tests in.

Acked-by: Shuah Khan <shuahkh@osg.samsung.com>

Please take this through powerpc maintainer git.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
