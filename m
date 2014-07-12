Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaGLBi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:38:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaGLBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:38:57 -0400
Date: Fri, 11 Jul 2014 18:43:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712014325.GB30781@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405128087.6751.12.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> A simple script to run checkpatch --fix for various types of
> of cleanups.
> 
> This script is useful primarily for staging.
> 
> This reformats code to a more CodingStyle conforming style,
> compiles it, verifies that the object code hasn't changed,
> and git commits it too.
> 
> You must have the necessary development tools, git, and a
> recent git tree.  Ideally use Greg KH's staging-next, which
> can be retrieved via these commands:
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> git checkout staging-next
> 
> To use this script try a sequence of commands like:
> 
> 	cd <linux_repository>
> 	git checkout -b <your_branch>
> 	make allyesconfig
> 	mkdir patches
> 	./scripts/reformat_with_checkpatch.sh drivers/staging/<dir>/*.[ch]
> 	git format-patch --cover-letter -o patches/<your_branch> staging-next
> 	git send-email patches/<your_branch>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/reformat_with_checkpatch.sh | 141 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 141 insertions(+)
>  create mode 100755 scripts/reformat_with_checkpatch.sh
> 
> diff --git a/scripts/reformat_with_checkpatch.sh b/scripts/reformat_with_checkpatch.sh
> new file mode 100755
> index 0000000..5415a8e
> --- /dev/null
> +++ b/scripts/reformat_with_checkpatch.sh
> @@ -0,0 +1,141 @@
> +#!/bin/bash
> +# (c) 2014, Joe Perches <joe@perches.com>
> +#
> +# Automate checkpatch modifications and git commits to
> +# neaten code that doesn't conform to CodingStyle.
> +# Useful primarily for files in drivers/staging
> +#
> +# Licensed under the terms of the GNU GPL License version 2
> +
> +declare -ar whitespace_types=(	\
> +    'whitespace_neatening:spacing,space_before_tab,pointer_location,trailing_whitespace,bracket_space'	\
> +    'remove_spaces_before_tabs:space_before_tab'		\
> +    'fix_label_positions:indented_label'		\
> +    'align_arguments_to_parenthesis:parenthesis_alignment'	\
> +)
> +
> +declare -ar changecode_types=(	\
> +    'fix_brace_positions:open_brace,braces,else_after_brace,while_after_brace'		\
> +    'fix_blank_lines:line_spacing'		\
> +    'use_standard_attributes:prefer_packed,prefer_aligned'		\
> +    'remove_unnecessary_externs:avoid_externs'		\
> +    'update_c90_comment_style:c99_comments'		\
> +)
> +
> +checkpatch_update ()
> +{
> +    file=$1
> +
> +    desc=$(echo $2 | cut -f1 -d: | sed 's/_/ /g')
> +    types=$(echo $2 | cut -f2- -d:)
> +
> +    echo "file: <$file> description: <$desc> types:<$types>"
> +
> +    ./scripts/checkpatch.pl --file --fix-inplace --strict --types="$types" $file
> +
> +    checkpatch_fixes=$file.diff
> +    git diff --stat -p --exit-code $file > $checkpatch_fixes
> +    if [ $? == 0 ] ; then
> +	rm -f $checkpatch_fixes
> +	return
> +    fi
> +
> +    basename=$(basename $file)
> +    if [ "${basename##*.}" == "c" ] ; then
> +
> +	git checkout $file
> +	obj="$(echo $file | sed 's/\.c$/\.o/')"
> +	if [ -e $obj ] ; then
> +	    rm -f $obj
> +	fi
> +
> +	echo "Compiling original version..."
> +
> +	${CROSS_COMPILE}make $obj
> +
> +	${CROSS_COMPILE}objdump -D $obj | \
> +	    sed "s/^[[:space:]]\+[0-9a-f]\+//" > $obj.old
> +
> +	patch -p1 < $checkpatch_fixes
> +
> +	echo "Compiling modified version..."
> +
> +	${CROSS_COMPILE}make $obj
> +
> +	${CROSS_COMPILE}objdump -D $obj | \
> +	    sed "s/^[[:space:]]\+[0-9a-f]\+//" > $obj.new
> +
> +	echo "Comparing objects..."
> +	diff -Nurd $obj.new $obj.old
> +	if [ $? -ne 0 ] ; then
> +	    echo "Object differences exist! - Verify changes before commit!"
> +	    read -s -p "Press the 'enter' key to continue: "
> +	else
> +	    echo "No object differences found"
> +	fi
> +	rm -f $obj.old
> +	rm -f $obj.new
> +    fi
> +
> +    echo "running checkpatch on possible checkpatch fixes..."
> +
> +    ./scripts/checkpatch.pl --no-summary --no-signoff $checkpatch_fixes
> +    rm -f $checkpatch_fixes
> +
> +    echo "Verify checkpatch output and make any necessary changes"
> +    echo "Edit '$file' if appropriate"
> +    read -s -p "Press the 'enter' key to continue: "
> +
> +    commit_log_file=$(mktemp git_commit.XXXXXX)
> +
> +    if [ -e $commit_log_file ] ; then
> +	rm -f $commit_log_file
> +    fi
> +
> +    if [[ $file =~ ^drivers/staging/ ]] ; then
> +	echo -n "staging: " >> $commit_log_file
> +    fi
> +    echo "$(basename $(dirname $file)): checkpatch cleanup: $desc" >> $commit_log_file

If I pick drivers/staging/lustre/include/linux/lnet/types.h, then I get:

	staging: lnet: checkpatch cleanup: whitespace neatening

and no 'types.h' here, is that intentional?  If so, why?

And this is fun, I'm going to let this rip on the lustre code...

thanks,

greg k-h
