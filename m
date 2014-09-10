Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaIJEUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:20:04 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:42041 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaIJEUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:20:01 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.130.137]
In-Reply-To: <1410321039-26888-1-git-send-email-guodong.xu@linaro.org>
References: <1410321039-26888-1-git-send-email-guodong.xu@linaro.org>
Date: Wed, 10 Sep 2014 12:20:00 +0800
Message-ID: <CAFRkauBBmEKNnc3M-CPAWQ8yMZFo6W-wj-M1qMmn3hGAYL6sTg@mail.gmail.com>
Subject: Re: [PATCH] regulator: remove unnecessary of_node_get() to parent
From: Axel Lin <axel.lin@ingics.com>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Support Opensource <support.opensource@diasemi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-10 11:50 GMT+08:00 Guodong Xu <guodong.xu@linaro.org>:
> These of_node_get() were added to balance refcount decrements inside of
> of_find_node_by_name().
> See: commit c92f5dd2c42f ("regulator: Add missing of_node_put()")
>
> However of_find_node_by_name() was then replaced by of_get_child_by_name(),
> which doesn't call of_node_put() against its input parameter.
>
> So, need to remove these unnecessary of_node_get() calls.

The of_node_get() and of_node_put() is a pair.
You need to either keep both or remove both.


BTW,
I think either the comment of of_get_child_by_name() needs fix or the
implementation
needs fix. The implementation does not increment refcount.

/**
 *      of_get_child_by_name - Find the child node by name for a given parent
 *      @node:  parent node
 *      @name:  child name to look for.
 *
 *      This function looks for child node for given matching name
 *
 *      Returns a node pointer if found, with refcount incremented, use
 *      of_node_put() on it when done.
 *      Returns NULL if node is not found.
 */

struct device_node *of_get_child_by_name(const struct device_node *node,
                                const char *name)
{
        struct device_node *child;

        for_each_child_of_node(node, child)
                if (child->name && (of_node_cmp(child->name, name) == 0))
                        break;
        return child;
}
EXPORT_SYMBOL(of_get_child_by_name);
