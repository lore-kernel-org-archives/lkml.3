Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaJ1NKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:10:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51752 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaJ1NKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:10:39 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-3e-544f95cc53e8
Message-id: <544F95C3.2080306@samsung.com>
Date: Tue, 28 Oct 2014 14:10:27 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] usb: gadget: don't create new string_container if already
 exist
References: <1414496039-5655-1-git-send-email-zhangwm@marvell.com>
In-reply-to: <1414496039-5655-1-git-send-email-zhangwm@marvell.com>
Content-type: text/plain; charset=iso-8859-2; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xy7pnpvqHGKy+w2Nx8H69RfPi9WwW
	l3fNYbNYtKyV2WL1xSXsDqwe++euYfeYvPAis8fxG9uZPD5vkgtgieKySUnNySxLLdK3S+DK
	+Nq+m61gJ2/F66ZXLA2M/dxdjBwcEgImEnsXe3UxcgKZYhIX7q1n62Lk4hASWMoo0X6jFcr5
	zChxqOUbM0gVr4CWxN2VLSwgNouAqsSjpmZGEJtNwFhi78EOMFtUIEzi9vr7LBD1ghI/Jt8D
	s0UE4iXu3u5nA7GZBXQkOo9uB7OFgeobtk4Amy8k4CTx9fg0VhCbU8BZ4viKK8wQ9dYSz448
	ZIWw5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgQ
	f93BuPSY1SFGAQ5GJR7eCBb/ECHWxLLiytxDjBIczEoivBExQCHelMTKqtSi/Pii0pzU4kOM
	TBycUg2M8xeZGMg+2mC575PJlGuP0lUlXjid9jvDIjlf+J+wws9tbY2LnhxlSw0Oj/knsVf5
	defshAqzkOjk6Z27VrzQeXL92Iwnv1U4zjXK/WFWkftycOVJ8w3hsZ8nWzsm7ZyySNFunQbL
	in35S9sc74vuW7UjKKR7o/kK1+Iss/b7/4tWOcSEB6xdqcRSnJFoqMVcVJwIAJsizJ9AAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

W dniu 28.10.2014 o 12:33, Neil Zhang pisze:
> Don't create new usb_gadget_string_container if the current strings are
> already exist in the usb_composite_dev.
> Otherwise the ids_tab will overflow soon if we bind / unbind usb
> functions frequently like android does.

The problem you are describing does not exist in mainline kernel,
where functions are always unbound as part of the whole gadget's
unbind - regardless of whether it is a legacy gadget or configfs-composed
gadget. When the whole gadget is unbound, composite_dev_cleanup()
is called which zeroes cdev->next_string_id and frees all gadget
strings containers.

>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>   drivers/usb/gadget/composite.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index a8c18df..6fe3c6b 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1183,6 +1183,12 @@ struct usb_string *usb_gstrings_attach(struct usb_composite_dev *cdev,
>   	if (!n_gstrings)
>   		return ERR_PTR(-EINVAL);
>
> +	list_for_each_entry(uc, &cdev->gstrings, list) {
> +		n_gs = get_containers_gs(uc);
> +		if (!strcmp(n_gs[0]->strings[0].s, sp[0]->strings[0].s))

To me it looks like it is a big assumption that if the first string matches,
the rest are the same, too. Isn't it?

Anyway, this solution looks more like pushing the moment when cdev->next_string_id
becomes 254 to a later time rather than preventing such a situation.

If usb_gstrings_attach() happens at function bind time, perhaps there
should be some usb_gstrings_detach() called at function unbind?

AP

