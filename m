Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaBHJT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 04:19:27 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:38999 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaBHJTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 04:19:24 -0500
Date: Sat, 8 Feb 2014 10:19:20 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 5/6] kbuild: Use single pass kallsyms
Message-ID: <20140208091920.GA400@x4>
References: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
 <1391845840-28514-5-git-send-email-ak@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391845840-28514-5-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.02.08 at 08:50 +0100, Andi Kleen wrote:
> -vmlinux_link "${kallsymso}" vmlinux
> +vmlinux_link "${kallsymsso}" vmlinux
> +if [ -n "${CONFIG_KALLSYMS}" ] ; then
> +	# Now regenerate the kallsyms table and patch it into the
> +	# previously linked file. We tell kallsyms to pad it
> +	# to the previous length, so that no symbol changes.
> +	info KALLSYMS2 .tmp_kallsyms2.o
> +	kallsyms vmlinux .tmp_kallsyms2.o $(<.kallsyms_pad)
> +
> +	info OBJCOPY .tmp_kallsyms2.bin
> +	${OBJCOPY} -O binary .tmp_kallsyms2.o .tmp_kallsyms2.bin
> +
> +	info PATCHFILE vmlinux
> +	OFF=$(${OBJDUMP} --section-headers vmlinux |
> +	     gawk -f ./source/scripts/elf_file_offset \
> +	-v section=.kallsyms -v filesize=$(stat -c%s .tmp_kallsyms2.bin) )
> +	if [ -z "$OFF" ] ; then
> +		echo "Cannot find .kallsyms section in vmlinux binary"
> +		exit 1
> +	fi
> +	scripts/patchfile vmlinux $OFF .tmp_kallsyms2.bin
> +fi

This causes: 
 gawk: fatal: can't open source file `./source/scripts/elf_file_offset' for reading (No such file or directory)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 4c5435f420a6..06469556c580 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -213,7 +213,7 @@ if [ -n "${CONFIG_KALLSYMS}" ] ; then
 
 	info PATCHFILE vmlinux
 	OFF=$(${OBJDUMP} --section-headers vmlinux |
-	     gawk -f ./source/scripts/elf_file_offset \
+	     gawk -f ./scripts/elf_file_offset \
 	-v section=.kallsyms -v filesize=$(stat -c%s .tmp_kallsyms2.bin) )
 	if [ -z "$OFF" ] ; then
 		echo "Cannot find .kallsyms section in vmlinux binary"

-- 
Markus
