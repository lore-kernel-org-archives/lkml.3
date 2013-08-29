Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3H2J1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:27:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45640 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab3H2J1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:27:47 -0400
Message-ID: <1377768462.2223.70.camel@dabdike>
Subject: Re: [RFC/PATCH 2/2] scsi: ufs: requests completion handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Raviv Shvili <rshvili@codeaurora.org>
Cc: scsi-misc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 29 Aug 2013 13:27:42 +0400
In-Reply-To: <1377766493-5269-1-git-send-email-rshvili@codeaurora.org>
References: <1377766493-5269-1-git-send-email-rshvili@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 11:54 +0300, Raviv Shvili wrote:
> The patch solves the request completion report order. At the current
> implementation, when multiple requests end at the same interrupt call,
> the requests reported as completed according to a bitmap scan from the
> lowest tags to the highest, regardless the requests priority. That cause
> to a priority unfairness and starvation of requests with a high tags.

It does?  Why?  What seems to happen is that you loop over all the
pending requests and call done for them.  The way SCSI handles done
commands is that it queues them to the softirq, so there doesn't look to
be any real unfairness problem here.

> SCSI Architecture Model 5 defines 3 task-attributes that are part of each
> SCSI command, and integrated into each Command UPIU. The task-attribute is
> for the device usage, it determines the order in which the device
> prioritizes the requests.
> The task-attributes according to their priority are (from high to low):
> HEAD OF QUEUE, ORDERED and SIMPLE. There is a queue per task-attribute.
> Each request is assigned to one of the above sw queues
> according to its task attribute field.
> Requests which are not SCSI commands (native UFS) will be assigned to
> the lowest priority queue, since there is no much difference between
> completing it first or last..
> 
> When request is completed, we go over the queues (from
> the queue's highest priority to the lowest) and report
> the completion.
> 
> Requests are removed from the queue in case of command completion
> or when aborting pending command.

Since we never use anything other than SIMPLE attributes, this rather
looks like a solution in search of a problem.

James


