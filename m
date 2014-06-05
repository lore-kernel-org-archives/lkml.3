Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaFEMMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:12:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:7201 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:12:49 -0400
Message-ID: <53905E98.3080709@huawei.com>
Date: Thu, 5 Jun 2014 20:12:08 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 3.4 214/214] HID: logitech: dont use stack based dj_report
 structures
References: <20140605041639.638675216@linuxfoundation.org>	<20140605041708.243134847@linuxfoundation.org> <CAB9dFdvqvqpF0b5mT63VjF2zDP4Eh7xGHX1iLFZY_NWk_YX7bQ@mail.gmail.com>
In-Reply-To: <CAB9dFdvqvqpF0b5mT63VjF2zDP4Eh7xGHX1iLFZY_NWk_YX7bQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -       dj_report.report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
>> -       return logi_dj_recv_send_report(djrcv_dev, &dj_report);
>> +       dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
> 
> This patch was unfortunately incorrect as is - it needs to allocate
> sizeof(struct dj_report) here and a little further down.  This was
> later fixed in mainline by 8a55ade7655, which should also be included
> if you take this - I don't see it in the current set.

Good catch, I'm so sorry, I missed this fix patch. Marc, thanks for your review.

Hi Greg, Can you cherry pick this fix patch?   upstream commit id: 8a55ade7655(dj: memory scribble in logi_dj).


Thanks!
Yijing.



> 
>> +       if (!dj_report)
>> +               return -ENOMEM;
>> +       dj_report->report_id = REPORT_ID_DJ_SHORT;
>> +       dj_report->device_index = 0xFF;
>> +       dj_report->report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
>> +       retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
>> +       kfree(dj_report);
>> +       return retval;
>>  }
>>
>>
>>  static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
>>                                           unsigned timeout)
>>  {
>> -       struct dj_report dj_report;
>> +       struct dj_report *dj_report;
>> +       int retval;
>>
>> -       memset(&dj_report, 0, sizeof(dj_report));
>> -       dj_report.report_id = REPORT_ID_DJ_SHORT;
>> -       dj_report.device_index = 0xFF;
>> -       dj_report.report_type = REPORT_TYPE_CMD_SWITCH;
>> -       dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
>> -       dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
>> -       return logi_dj_recv_send_report(djrcv_dev, &dj_report);
>> +       dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
> 
> Same here.
> 
>> +       if (!dj_report)
>> +               return -ENOMEM;
>> +       dj_report->report_id = REPORT_ID_DJ_SHORT;
>> +       dj_report->device_index = 0xFF;
>> +       dj_report->report_type = REPORT_TYPE_CMD_SWITCH;
>> +       dj_report->report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
>> +       dj_report->report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
>> +       retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
>> +       kfree(dj_report);
>> +       return retval;
>>  }
> 
> Marc
> 
> .
> 


-- 
Thanks!
Yijing

