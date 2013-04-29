Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab3D2McN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:32:13 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60555 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab3D2McL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:32:11 -0400
MIME-Version: 1.0
Date: Mon, 29 Apr 2013 05:32:11 -0700
Message-ID: <CANN689GoQm8dGEN6L1xuuc_aZ_65G3N7tBPbEXHjAfebB7xrLw@mail.gmail.com>
Subject: ACPI fan driver: uninitialized variable when CONFIG_PM is not set
From: Michel Lespinasse <walken@google.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following code:

static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
                             *state)
{
        struct acpi_device *device = cdev->devdata;
        int result;
        int acpi_state;

        if (!device)
                return -EINVAL;

        result = acpi_bus_update_power(device->handle, &acpi_state);
        if (result)
                return result;

        *state = (acpi_state == ACPI_STATE_D3 ? 0 :
                 (acpi_state == ACPI_STATE_D0 ? 1 : -1));
        return 0;
}

With CONFIG_PM not set, acpi_bus_update_power() returns 0 and does not
initialize acpi_state. This results in acpi_state being used before
initialization.

(I found out by random chance, as I suppose people don't normally
build without CONFIG_PM anymore ?)

I'm not sure what a proper fix would be, so I'll just report this here
and enable CONFIG_PM locally :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
