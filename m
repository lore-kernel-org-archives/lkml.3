Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaLDAhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:37:07 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45295 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaLDAhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:37:05 -0500
X-Originating-IP: 50.43.43.148
Date: Wed, 3 Dec 2014 16:36:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Tim Bird <tim.bird@sonymobile.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] selftest: size: Add size test for Linux kernel
Message-ID: <20141204003653.GA5004@thin>
References: <547F598D.7030205@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547F598D.7030205@sonymobile.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 10:42:21AM -0800, Tim Bird wrote:
> This test shows the amount of memory used by the system.
> Note that this is dependent on the user-space that is loaded
> when this program runs.  Optimally, this program would be
> run as the init program itself.
> 
> The program is optimized for size itself, to avoid conflating
> its own execution with that of the system software.
> The code is compiled statically, with no stdlibs. On my x86_64 system,
> this results in a statically linked binary of less than 5K.
> 
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>

v6 looks good to me.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Should this go through the tinification tree or the selftests tree?

- Josh Triplett

> Changes from v5:
>   - remove #ifdef in Makefile (doh!)
>   - use variables in build command
>   - use different num_to_str, with less conversions
> 
> Changes from v4:
>   - make most routines static
>   - replace strip with gcc -s
>   - remove explicit reference to _start
>   - change --static to -static
>   - remove explicit reference to LIBGCC
>   - fix test description for ok and not ok paths, for test 1
> 
> Changes from v3:
>   - add more human-readable output
>   - put libgcc reference into a variable in Makefile
> 
> Changes from v2:
>   - fix copyright string (again!)
>   - use __builtin_strlen instead of my own strlen
>   - replace main with _start
> 
> Changes from v1:
>   - add return values to print routines
>   - add .gitignore file
>   - use more correct Copyright string in get_size.c
> 
>  tools/testing/selftests/Makefile        |   1 +
>  tools/testing/selftests/size/.gitignore |   1 +
>  tools/testing/selftests/size/Makefile   |  12 ++++
>  tools/testing/selftests/size/get_size.c | 100 ++++++++++++++++++++++++++++++++
>  4 files changed, 114 insertions(+)
>  create mode 100644 tools/testing/selftests/size/.gitignore
>  create mode 100644 tools/testing/selftests/size/Makefile
>  create mode 100644 tools/testing/selftests/size/get_size.c
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 45f145c..fa91aef 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -15,6 +15,7 @@ TARGETS += user
>  TARGETS += sysctl
>  TARGETS += firmware
>  TARGETS += ftrace
> +TARGETS += size
>  
>  TARGETS_HOTPLUG = cpu-hotplug
>  TARGETS_HOTPLUG += memory-hotplug
> diff --git a/tools/testing/selftests/size/.gitignore b/tools/testing/selftests/size/.gitignore
> new file mode 100644
> index 0000000..189b781
> --- /dev/null
> +++ b/tools/testing/selftests/size/.gitignore
> @@ -0,0 +1 @@
> +get_size
> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
> new file mode 100644
> index 0000000..04dc25e
> --- /dev/null
> +++ b/tools/testing/selftests/size/Makefile
> @@ -0,0 +1,12 @@
> +CC = $(CROSS_COMPILE)gcc
> +
> +all: get_size
> +
> +get_size: get_size.c
> +	$(CC) -static -ffreestanding -nostartfiles -s $< -o $@
> +
> +run_tests: all
> +	./get_size
> +
> +clean:
> +	$(RM) get_size
> diff --git a/tools/testing/selftests/size/get_size.c b/tools/testing/selftests/size/get_size.c
> new file mode 100644
> index 0000000..2d1af7c
> --- /dev/null
> +++ b/tools/testing/selftests/size/get_size.c
> @@ -0,0 +1,100 @@
> +/*
> + * Copyright 2014 Sony Mobile Communications Inc.
> + *
> + * Licensed under the terms of the GNU GPL License version 2
> + *
> + * Selftest for runtime system size
> + *
> + * Prints the amount of RAM that the currently running system is using.
> + *
> + * This program tries to be as small as possible itself, to
> + * avoid perturbing the system memory utilization with its
> + * own execution.  It also attempts to have as few dependencies
> + * on kernel features as possible.
> + *
> + * It should be statically linked, with startup libs avoided.
> + * It uses no library calls, and only the following 3 syscalls:
> + *   sysinfo(), write(), and _exit()
> + *
> + * For output, it avoids printf (which in some C libraries
> + * has large external dependencies) by  implementing it's own
> + * number output and print routines, and using __builtin_strlen()
> + */
> +
> +#include <sys/sysinfo.h>
> +#include <unistd.h>
> +
> +#define STDOUT_FILENO 1
> +
> +static int print(const char *s)
> +{
> +	return write(STDOUT_FILENO, s, __builtin_strlen(s));
> +}
> +
> +static inline char *num_to_str(unsigned long num, char *buf, int len)
> +{
> +	unsigned int digit;
> +
> +	/* put digits in buffer from back to front */
> +	buf += len - 1;
> +	*buf = 0;
> +	do {
> +		digit = num % 10;
> +		*(--buf) = digit + '0';
> +		num /= 10;
> +	} while (num > 0);
> +
> +	return buf;
> +}
> +
> +static int print_num(unsigned long num)
> +{
> +	char num_buf[30];
> +
> +	return print(num_to_str(num, num_buf, sizeof(num_buf)));
> +}
> +
> +static int print_k_value(const char *s, unsigned long num, unsigned long units)
> +{
> +	unsigned long long temp;
> +	int ccode;
> +
> +	print(s);
> +
> +	temp = num;
> +	temp = (temp * units)/1024;
> +	num = temp;
> +	ccode = print_num(num);
> +	print("\n");
> +	return ccode;
> +}
> +
> +/* this program has no main(), as startup libraries are not used */
> +void _start(void)
> +{
> +	int ccode;
> +	struct sysinfo info;
> +	unsigned long used;
> +
> +	print("Testing system size.\n");
> +	print("1..1\n");
> +
> +	ccode = sysinfo(&info);
> +	if (ccode < 0) {
> +		print("not ok 1 get runtime memory use\n");
> +		print("# could not get sysinfo\n");
> +		_exit(ccode);
> +	}
> +	/* ignore cache complexities for now */
> +	used = info.totalram - info.freeram - info.bufferram;
> +	print_k_value("ok 1 get runtime memory use # size = ", used,
> +		info.mem_unit);
> +
> +	print("# System runtime memory report (units in Kilobytes):\n");
> +	print_k_value("#   Total:  ", info.totalram, info.mem_unit);
> +	print_k_value("#   Free:   ", info.freeram, info.mem_unit);
> +	print_k_value("#   Buffer: ", info.bufferram, info.mem_unit);
> +	print_k_value("#   In use: ", used, info.mem_unit);
> +
> +	_exit(0);
> +}
> -- 
> 1.8.2.2
> 
