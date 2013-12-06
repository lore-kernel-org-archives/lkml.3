Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3LFDTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:19:51 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39614 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LFDTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:19:48 -0500
Message-ID: <52A1424F.5060007@gmail.com>
Date: Thu, 05 Dec 2013 19:19:43 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Bolle <pebolle@tiscali.nl>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 2/4] pciehp: Use link change notifications for hot-plug
 and removal
References: <529E5C0E.80903@gmail.com> <52A04235.9010801@huawei.com>
In-Reply-To: <52A04235.9010801@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 01:07 AM, Yijing Wang wrote:
> 
> handle_link_up_event() and handle_link_down_event() are almost the same,
> what about use like:
> handle_link_state_change_event(p_slot, event) to reuse the the common code ?
> 
>

Sure, I can combine both of them to make it look more like this. Let me know
it this looks all right.

static void handle_link_event(struct slot *p_slot, unsigned int req)
{
	struct controller *ctrl = p_slot->ctrl;
	struct power_work_info *info;

	info = kmalloc(sizeof(*info), GFP_KERNEL);
	if (!info) {
		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
			 __func__);
		return;
	}
	info->p_slot = p_slot;
	info->req = req;
	INIT_WORK(&info->work, pciehp_power_thread);

	switch (p_slot->state) {
	case BLINKINGON_STATE:
	case BLINKINGOFF_STATE:
		cancel_delayed_work(&p_slot->work);
		/* Fall through */
	case STATIC_STATE:
		if (req == ENABLE_REQ)
			p_slot->state = POWERON_STATE;
		else
			p_slot->state = POWEROFF_STATE;

		queue_work(p_slot->wq, &info->work);
		break;
	case POWERON_STATE:
		if (req == ENABLE_REQ) {
			ctrl_info(ctrl,
				  "Link Up ignored on slot(%s): already powering on\n",
				  slot_name(p_slot));
			kfree(info);
		} else {
			ctrl_info(ctrl,
				  "Link Down queued on slot(%s): currently getting powered on\n",
				  slot_name(p_slot));
			p_slot->state = POWEROFF_STATE;
			queue_work(p_slot->wq, &info->work);
		}
		break;
	case POWEROFF_STATE:
		if (req == ENABLE_REQ) {
			ctrl_info(ctrl,
				  "Link Up queued on slot(%s): currently getting powered off\n",
				  slot_name(p_slot));
			p_slot->state = POWERON_STATE;
			queue_work(p_slot->wq, &info->work);
		} else {
			ctrl_info(ctrl,
				  "Link Down ignored on slot(%s): already powering off\n",
				  slot_name(p_slot));
			kfree(info);
		}
		break;
	default:
		ctrl_err(ctrl, "Not a valid state on slot(%s)\n",
			 slot_name(p_slot));
		kfree(info);
		break;
	}
}

Bjorn: was wondering if you'd able to take a look at this patchset in
this or next week some time. I'm eagerly waiting to address any comments.

Also, can you please let me know what is the protocol here? Should
I resubmit just the "v3" of this patch? Or bump up the version of all
the patches in the patchset to "v3" and resubmit them all?

Thanks & Best Regards,

Rajat
