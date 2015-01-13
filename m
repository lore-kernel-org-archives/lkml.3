Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbbAMPYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:24:17 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49542 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbbAMPYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:24:15 -0500
Message-ID: <54B5389E.4060409@osg.samsung.com>
Date: Tue, 13 Jan 2015 08:24:14 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org
Subject: Re: [PATCH V2 10/12] selftests, powerpc: Add test for DSCR inheritence
 across fork & exec
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com> <1421144560-15901-11-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1421144560-15901-11-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:22 AM, Anshuman Khandual wrote:
> This patch adds a test case to verify that the changed DSCR value
> inside any process would be inherited to it's child across the fork
> and exec system call.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  tools/testing/selftests/powerpc/dscr/Makefile      |   2 +-
>  .../powerpc/dscr/dscr_inherit_exec_test.c          | 118 +++++++++++++++++++++
>  2 files changed, 119 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_inherit_exec_test.c
> 
> diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
> index 81239e2..4e84309 100644
> --- a/tools/testing/selftests/powerpc/dscr/Makefile
> +++ b/tools/testing/selftests/powerpc/dscr/Makefile
> @@ -1,5 +1,5 @@
>  PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
> -	 dscr_inherit_test
> +	 dscr_inherit_test dscr_inherit_exec_test
>  
>  CFLAGS := $(CFLAGS) -lpthread
>  
> diff --git a/tools/testing/selftests/powerpc/dscr/dscr_inherit_exec_test.c b/tools/testing/selftests/powerpc/dscr/dscr_inherit_exec_test.c
> new file mode 100644
> index 0000000..5ff3849
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/dscr/dscr_inherit_exec_test.c
> @@ -0,0 +1,118 @@
> +/*
> + * POWER Data Stream Control Register (DSCR) fork exec test
> + *
> + * This testcase modifies the DSCR using mtspr, forks & execs and
> + * verifies that the child is using the changed DSCR using mfspr.
> + *
> + * When using the privilege state SPR, the instructions such as
> + * mfspr or mtspr are priviledged and the kernel emulates them
> + * for us. Instructions using problem state SPR can be exuecuted
> + * directly without any emulation if the HW supports them. Else
> + * they also get emulated by the kernel.
> + *
> + * Copyright (C) 2012 Anton Blanchard <anton@au.ibm.com>, IBM
> + * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +#include "dscr.h"
> +
> +static char prog[LEN_MAX];
> +
> +static void do_exec(unsigned long parent_dscr)
> +{
> +	unsigned long cur_dscr, cur_dscr_usr;
> +
> +	cur_dscr = get_dscr();
> +	cur_dscr_usr = get_dscr_usr();
> +
> +	if (cur_dscr != parent_dscr) {
> +		fprintf(stderr, "Parent DSCR %ld was not inherited "
> +				"over exec (kernel value)\n", parent_dscr);
> +		exit(1);
> +	}
> +
> +	if (cur_dscr_usr != parent_dscr) {
> +		fprintf(stderr, "Parent DSCR %ld was not inherited "
> +				"over exec (user value)\n", parent_dscr);
> +		exit(1);
> +	}
> +	exit(0);
> +}
> +
> +int test_body(void)
> +{
> +	unsigned long i, dscr = 0;
> +	pid_t pid;
> +
> +	for (i = 0; i < COUNT; i++) {
> +		dscr++;
> +		if (dscr > DSCR_MAX)
> +			dscr = 0;
> +
> +		if (dscr == get_default_dscr())
> +			continue;
> +
> +		if (i % 2 == 0)
> +			set_dscr_usr(dscr);
> +		else
> +			set_dscr(dscr);
> +
> +		/*
> +		 * XXX: Force a context switch out so that DSCR
> +		 * current value is copied into the thread struct
> +		 * which is required for the child to inherit the
> +		 * changed value.
> +		 */
> +		sleep(1);
> +
> +		pid = fork();
> +		if (pid == -1) {
> +			perror("fork() failed\n");
> +			exit(1);
> +		} else if (pid) {
> +			int status;
> +
> +			if (waitpid(pid, &status, 0) == -1) {
> +				perror("waitpid() failed\n");
> +				exit(1);
> +			}
> +
> +			if (!WIFEXITED(status)) {
> +				fprintf(stderr, "Child didn't exit cleanly\n");
> +				exit(1);
> +			}
> +
> +			if (WEXITSTATUS(status) != 0) {
> +				fprintf(stderr, "Child didn't exit cleanly\n");
> +				return 1;
> +			}
> +		} else {
> +			char dscr_str[16];
> +
> +			sprintf(dscr_str, "%ld", dscr);
> +			execlp(prog, prog, "exec", dscr_str, NULL);
> +			exit(1);
> +		}
> +	}
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	if (argc == 3 && !strcmp(argv[1], "exec")) {
> +		unsigned long parent_dscr;
> +
> +		parent_dscr = atoi(argv[2]);
> +		do_exec(parent_dscr);
> +	} else if (argc != 1) {
> +		fprintf(stderr, "Usage: %s\n", argv[0]);
> +		exit(1);
> +	}
> +
> +	strncpy(prog, argv[0], strlen(argv[0]));
> +	return test_harness(test_body, "dscr_inherit_exec_test");
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
