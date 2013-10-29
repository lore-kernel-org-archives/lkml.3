Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3J2SG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:06:27 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45413 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab3J2SGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:06:24 -0400
Date: Tue, 29 Oct 2013 19:06:19 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: mmarek@suse.cz, akpm@linux-foundation.org, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
Message-ID: <20131029180619.GC3411@free.fr>
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael, All,

On 2013-10-24 07:23 +0200, Michael Opdenacker spake thusly:
> This is the first version of a script to look for
> Kconfig parameters which are still defined but no longer
> used in the kernel source code.
> 
> The script may be extended in the future to perform
> more checks. This explains why a rather generic name was chosen.
> 
> Several issues have already been reported and fixed
> thanks to the use of this script. It is time to share it now!

I'm not much of a Python guy, so I'll gleefully rely on the previous
comments to guide you in your endeavour.

/me is feeling poetical, tonight! ;-)

I however have a suggestion, see below.

> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  scripts/checkkconfig.py | 131 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100755 scripts/checkkconfig.py
> 
> diff --git a/scripts/checkkconfig.py b/scripts/checkkconfig.py
> new file mode 100755
> index 0000000..4155656
> --- /dev/null
> +++ b/scripts/checkkconfig.py
> @@ -0,0 +1,131 @@
[--SNIP--]
> +def count_param(param):
> +
> +    global source_file, bad_params_in_file
> +
> +    if os.path.isdir('.git'):
> +       # Use git grep when available
> +       count = subprocess.check_output('git grep ' + param + '| grep -v defconfig | wc -l', shell=True)
> +    else:
> +       # Fallback to regular grep
> +       count = subprocess.check_output('grep -R ' + param + ' . | grep -v defconfig | wc -l', shell=True)
> +
> +    num = int(count.strip())
> +
> +    if num == 1:
> +       'WARNING: parameter ' + param + ' is used nowhere'
> +
> +       file=source_file[param]
> +
> +       if bad_params_in_file.has_key(file):
> +          bad_params_in_file[file].append(param)
> +       else:
> +	  bad_params_in_file[file]=[param]
> +
> +
> +########################################################
> +# Main program
> +########################################################
[--SNIP--]
> +for param in has_select.keys():
> +
> +    # Progress information... running the script can take hours!

I guess all these grep spawning are what makes it slow.

I wonder if it would not be possible to invert the loop (in pseudo
Python code):

    for f in all_interesting_files:
        read f in memory
        for s in all_symbols:
            if symbol is in f:
                remove f from all_symbols
                break the inner-most loop

This way:
  - you scan the tree only once
  - as soon as a symbol is matched, it is removed, thus decreasing
    the amount of checks done in further loops.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
