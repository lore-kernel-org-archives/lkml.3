Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaJXXQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:16:53 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:58908 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaJXXQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <544adba2.KkIWF+RUrgArDyJb%fengguang.wu@intel.com>
References: <544adba2.KkIWF+RUrgArDyJb%fengguang.wu@intel.com>
Date: Fri, 24 Oct 2014 16:16:50 -0700
X-Google-Sender-Auth: S_rpvA2aQyVLXD8prPhZv1s_4nE
Message-ID: <CAGXu5jLAa4ru9d-AhouE65vU5eLbMtjUbsmOeUkvEuwHspWGAw@mail.gmail.com>
Subject: Re: [linux-devel:devel-hourly-2014102506 48/69] net/wireless/core.c:374:3:
 error: format not a string literal and no format arguments
From: Kees Cook <keescook@chromium.org>
To: Ben Greear <greearb@candelatech.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 24, 2014 at 4:07 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
>    net/wireless/core.c: In function 'wiphy_new_nm':
>>> net/wireless/core.c:374:3: error: format not a string literal and no format arguments [-Werror=format-security]
>       rv = dev_set_name(&rdev->wiphy.dev, requested_name);
>       ^
>    cc1: some warnings being treated as errors
>
> vim +374 net/wireless/core.c
>
> 704232c2 Johannes Berg 2007-04-23  358
> 9b881963 Johannes Berg 2013-06-04  359          /* atomic_inc_return makes it start at 1, make it start at 0 */
> 9b881963 Johannes Berg 2013-06-04  360          rdev->wiphy_idx--;
> 9b881963 Johannes Berg 2013-06-04  361
> 7623225f Johannes Berg 2010-10-11  362          /* give it a proper name */
> 3fea0bc6 Ben Greear    2014-10-22  363          if (requested_name && requested_name[0]) {
> 3fea0bc6 Ben Greear    2014-10-22  364                  int rv;
> 3fea0bc6 Ben Greear    2014-10-22  365
> 3fea0bc6 Ben Greear    2014-10-22  366                  rtnl_lock();
> 3fea0bc6 Ben Greear    2014-10-22  367                  rv = cfg80211_dev_check_name(rdev, requested_name);
> 3fea0bc6 Ben Greear    2014-10-22  368
> 3fea0bc6 Ben Greear    2014-10-22  369                  if (rv < 0) {
> 3fea0bc6 Ben Greear    2014-10-22  370                          rtnl_unlock();
> 3fea0bc6 Ben Greear    2014-10-22  371                          goto use_default_name;
> 3fea0bc6 Ben Greear    2014-10-22  372                  }
> 3fea0bc6 Ben Greear    2014-10-22  373
> 3fea0bc6 Ben Greear    2014-10-22 @374                  rv = dev_set_name(&rdev->wiphy.dev, requested_name);

Please make this:

rv = dev_set_name(&rdev->wiphy.dev, "%s", requested_name);

to avoid format string leaks via the device name.

Thanks!

-Kees

> 3fea0bc6 Ben Greear    2014-10-22  375                  rtnl_unlock();
> 3fea0bc6 Ben Greear    2014-10-22  376                  if (rv)
> 3fea0bc6 Ben Greear    2014-10-22  377                          goto use_default_name;
> 3fea0bc6 Ben Greear    2014-10-22  378          } else {
> 3fea0bc6 Ben Greear    2014-10-22  379  use_default_name:
> 3fea0bc6 Ben Greear    2014-10-22  380                  /* NOTE:  This is *probably* safe w/out holding rtnl because of
> 3fea0bc6 Ben Greear    2014-10-22  381                   * the restrictions on phy names.  Probably this call could
> 3fea0bc6 Ben Greear    2014-10-22  382                   * fail if some other part of the kernel (re)named a device
>
> :::::: The code at line 374 was first introduced by commit
> :::::: 3fea0bc6ccb485342ce149a100d4effa029fa975 cfg80211: support creating wiphy with suggested name
>
> :::::: TO: Ben Greear <greearb@candelatech.com>
> :::::: CC: Johannes Berg <johannes.berg@intel.com>
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Kees Cook
Chrome OS Security
