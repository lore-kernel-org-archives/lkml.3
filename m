Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaDVMKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:10:39 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:58216 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDVMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:10:36 -0400
Date: Tue, 22 Apr 2014 14:10:35 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: probable cause found - 3.14 on Xenserver (non-HVM): "cannot allocate
 memory")
Message-ID: <20140422121035.GA23364@torres.zugschlus.de>
References: <20140420205639.GA22293@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140420205639.GA22293@torres.zugschlus.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 20, 2014 at 10:56:39PM +0200, Marc Haber wrote:
> Linux 3.14, however, does not yet beyond the initramfs state ("cannot
> allocate memory". This also happens when i set cgroup_disable=memory.

After doing a bisect between "good 3.13" and "bad 3.14", I ended up
with this commit:

6145cfe394a7f138f6b64491c5663f97dba12450 is the first bad commit
commit 6145cfe394a7f138f6b64491c5663f97dba12450
Author: Kees Cook <keescook@chromium.org>
Date:   Thu Oct 10 17:18:18 2013 -0700

    x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64

    On 64-bit, this raises the maximum location to -1 GiB (from -1.5 GiB),
    the upper limit currently, since the kernel fixmap page mappings need
    to be moved to use the other 1 GiB (which would be the theoretical
    limit when building with -mcmodel=kernel).

    Signed-off-by: Kees Cook <keescook@chromium.org>
    Link: http://lkml.kernel.org/r/1381450698-28710-7-git-send-email-keescook@chromium.org
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

:040000 040000 a48a6355e3ccd676027319ff520bf953cb07a0bb 7beb1fdd7478b6bec2555a364fbfac29d7a5a3c4 M       arch

and, indeed, reverting this commit on plain 3.14.1 makes my Xenserver
boot just fine. When reverting the patch, I took the liberty of
ignoring the REJECT in arch/x86/Kconfig.

I am, however, a bit confused that this patch dates back to october
while the breakage only occurred when 3.14 was released.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062
