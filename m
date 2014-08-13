Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaHMJnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:43:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaHMJnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:43:22 -0400
Message-ID: <53EB3337.3030809@suse.com>
Date: Wed, 13 Aug 2014 11:43:19 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] Make bind_interdomain_evtchn_to_irq() public
References: <1407851024-18936-1-git-send-email-jgross@suse.com> <53EB3014.8090008@citrix.com>
In-Reply-To: <53EB3014.8090008@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 11:29 AM, David Vrabel wrote:
> On 12/08/14 14:43, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> bind_interdomain_evtchn_to_irq() is currently a private function. It is used
>> only by bind_interdomain_evtchn_to_irqhandler() to register an irq-handler for
>> an event channel.
>>
>> By making it public it is possible to use e.g. threaded interrupts with
>> interdomain event channels.
>
> Can you give an example of using this?  Maybe we want a
> bind_interdomain_evtchn_to_threaded_irqhandler() instead? Or add a flags
> field to the existing function.

Instead of

static int scsiback_schedule(void *data)
{
        struct vscsibk_info *info = (struct vscsibk_info *)data;

        while (!kthread_should_stop()) {
                wait_event_interruptible(info->wq,
                        info->waiting_reqs || kthread_should_stop());

                info->waiting_reqs = 0;
                smp_mb();       /* waiting_reqs used by other thread */

                switch (scsiback_do_cmd_fn(info)) {
                case 1:
                        info->waiting_reqs = 1;
                default:
                        break;
                }
                cond_resched();
        }
        return 0;
}

static void scsiback_notify_work(struct vscsibk_info *info)
{
        info->waiting_reqs = 1;
        wake_up(&info->wq);
}

static irqreturn_t scsiback_intr(int irq, void *dev_id)
{
        scsiback_notify_work((struct vscsibk_info *)dev_id);
        return IRQ_HANDLED;
}

static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t 
ring_ref,
                        evtchn_port_t evtchn)
{
...
        bind_interdomain_evtchn_to_irqhandler(
                        info->domid, evtchn,
                        scsiback_intr, 0, "vscsiif-backend", info);

...
        info->kthread = kthread_run(scsiback_schedule, info, name);
...
}


I only need the following:

static irqreturn_t scsiback_irq_fn(int irq, void *dev_id)
{
         struct vscsibk_info *info = dev_id;

         while (scsiback_do_cmd_fn(info))
                 cond_resched();

         return IRQ_HANDLED;
}

static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t 
ring_ref,
                         evtchn_port_t evtchn)
{
...
         irq = bind_interdomain_evtchn_to_irq(info->domid, evtchn);
         request_threaded_irq(irq, NULL, scsiback_irq_fn,
                              IRQF_ONESHOT, "vscsiif-backend", info)
...
}


So yes, it could be done via a flag, too.

Juergen
