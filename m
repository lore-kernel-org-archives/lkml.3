Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaDQSEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:04:05 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:50519 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDQSDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <1397511430-2673-13-git-send-email-tj@kernel.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
	<1397511430-2673-13-git-send-email-tj@kernel.org>
Date: Thu, 17 Apr 2014 23:33:50 +0530
X-Google-Sender-Auth: 9MyXHKRiHu1qjfZluyoGkzu0w1Q
Message-ID: <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw@mail.gmail.com>
Subject: Re: [PATCH 12/12] cgroup: implement dynamic subtree controller
 enable/disable on the default hierarchy
From: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 3:07 AM, Tejun Heo <tj@kernel.org> wrote:
[...]
> * White-space separated list of controller names prefixed with either
>   '+' or '-' can be written to "cgroup.subtree_control".  The ones
>   prefixed with '+' are enabled on the controller and '-' disabled.
>

[...]

> +
> +/* change the enabled child controllers for a cgroup in the default hierarchy */
> +static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
> +                                       struct cftype *cft, char *buffer)
> +{
> +       unsigned long enable_req = 0, disable_req = 0, enable, disable;
> +       struct cgroup *cgrp = dummy_css->cgroup, *child;
> +       struct cgroup_subsys *ss;
> +       char *tok, *p;
> +       int ssid, ret;
> +
> +       /*
> +        * Parse input - white space separated list of subsystem names
> +        * prefixed with either + or -.
> +        */
> +       p = buffer;
> +       while ((tok = strsep(&p, " \t\n"))) {
> +               for_each_subsys(ss, ssid) {
> +                       if (ss->disabled || strcmp(tok + 1, ss->name))
> +                               continue;
> +
> +                       if (*tok == '+') {
> +                               enable_req |= 1 << ssid;
> +                               disable_req &= ~(1 << ssid);
> +                       } else if (*tok == '-') {
> +                               disable_req |= 1 << ssid;
> +                               enable_req &= ~(1 << ssid);
> +                       } else {
> +                               return -EINVAL;
> +                       }
> +                       break;
> +               }
> +               if (ssid == CGROUP_SUBSYS_COUNT)
> +                       return -EINVAL;
> +       }

I undertsand that with the above parsing we could do
echo "-blkio +blkio" > cgroup.subtree_control and honor last enable/disable.
It confused me while testing. do you think we should return -EINVAL in
such case?
