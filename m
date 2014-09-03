Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbaICJ6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25727 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaICJ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:52 -0400
Date: Wed, 3 Sep 2014 12:57:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rickard_strandqvist@spectrumdigital.se,
        Nicholas Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: re: target: target_core_transport.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Message-ID: <20140903095742.GA5058@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 6cfa853ceee4: "target: target_core_transport.c: Cleaning up
missing null-terminate in conjunction with strncpy" from Aug 3, 2014,
leads to the following static checker warning:

	drivers/target/target_core_transport.c:956 transport_dump_vpd_ident_type()
	error: potentially dereferencing uninitialized 'len'.

drivers/target/target_core_transport.c
   955          default:
   956                  len = strlen(len);
                        ^^^^^^^^^^^^^^^^^

This was obviously supposed to be strlen(buf) and no one compile tested
it...  But the patch is called "missing null-terminate" when actually
the original code was fine as far as I can see.

Apparently, as a safety measure we're trying to replace every strncpy()
with:

	strncpy(foo, bar, sizeof(foo));
	foo[sizeof(foo) - 1] = '\0';

We should have a function for this.  We used to use strlcpy() but people
complained that it could read beyond the end of the src string.  Also it
doesn't pad the string with zeros.  So now we're open coding NUL
terminators everywhere so the code is easier to audit.

That sucks and makes the code messier.

Rickard, please, let's find a cleaner way to do this.

regards,
dan carpenter
